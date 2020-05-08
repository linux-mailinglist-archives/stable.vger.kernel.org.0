Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D780A1CAEB5
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729420AbgEHMqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:46:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729415AbgEHMqQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:46:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D34DA208D6;
        Fri,  8 May 2020 12:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941976;
        bh=V0RjYQzndmgrEhZdr+EFbf5EKNuTl5UrmHdYyB6ZKv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BwYI20wzM2Ktnx4/A1kTarfU4uFCsr6TXhHvlHUrE5sYMzceZo3AX7YPSlL6ituFz
         LHltVnvrp1k/CkdJns3ZPLPwiWLWrf4/tq/dKzsKxGMdh5xrkQYE0snYUf9y0I0Agj
         rTG3ushkjWmZD5SG+HhO4qQYVTYx6hU/xx0uKYVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCH 4.4 230/312] power: test_power: correctly handle empty writes
Date:   Fri,  8 May 2020 14:33:41 +0200
Message-Id: <20200508123140.616507722@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>

commit 6b9140f39c2aaf76791197fbab0839c0e4af56e8 upstream.

Writing 0 length data into test_power makes it access an invalid array
location and kill the system.

Fixes: f17ef9b2d ("power: Make test_power driver more dynamic.")
Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/power/test_power.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/power/test_power.c
+++ b/drivers/power/test_power.c
@@ -301,6 +301,8 @@ static int map_get_value(struct battery_
 	buf[MAX_KEYLENGTH-1] = '\0';
 
 	cr = strnlen(buf, MAX_KEYLENGTH) - 1;
+	if (cr < 0)
+		return def_val;
 	if (buf[cr] == '\n')
 		buf[cr] = '\0';
 


