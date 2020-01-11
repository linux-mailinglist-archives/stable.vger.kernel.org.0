Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCBDF138055
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbgAKK2Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:28:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:35826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731047AbgAKK2Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:28:24 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5440205F4;
        Sat, 11 Jan 2020 10:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738503;
        bh=h5NfLAMahDeyBWLnNDHOkNGkRzHip58O6rBMQh4p7X4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=paq/kgpU0wUFFQeek+xRBxBiP/rB22SgxPY8wWEbFOHYsDo9bmpmeeB7wLgvf6Reo
         Kzuj4JckBT0kMbRX7T37wJUbcXPUGHapC6HI5WEdbd0mSXgOkOsdvYznHe/DV/8DLB
         QIu4Oc6Jtox3ZUmYW7/Uk0VVwz3eE7G+JjrJItnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 089/165] rfkill: Fix incorrect check to avoid NULL pointer dereference
Date:   Sat, 11 Jan 2020 10:50:08 +0100
Message-Id: <20200111094928.612233905@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit 6fc232db9e8cd50b9b83534de9cd91ace711b2d7 ]

In rfkill_register, the struct rfkill pointer is first derefernced
and then checked for NULL. This patch removes the BUG_ON and returns
an error to the caller in case rfkill is NULL.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Link: https://lore.kernel.org/r/20191215153409.21696-1-pakki001@umn.edu
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rfkill/core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 0bf9bf1ceb8f..6c089320ae4f 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -1002,10 +1002,13 @@ static void rfkill_sync_work(struct work_struct *work)
 int __must_check rfkill_register(struct rfkill *rfkill)
 {
 	static unsigned long rfkill_no;
-	struct device *dev = &rfkill->dev;
+	struct device *dev;
 	int error;
 
-	BUG_ON(!rfkill);
+	if (!rfkill)
+		return -EINVAL;
+
+	dev = &rfkill->dev;
 
 	mutex_lock(&rfkill_global_mutex);
 
-- 
2.20.1



