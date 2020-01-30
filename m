Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F275014E192
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731059AbgA3Spg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:45:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:55278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728079AbgA3Spg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:45:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB42221734;
        Thu, 30 Jan 2020 18:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409936;
        bh=krs1E6STY5LR20e9JwyiHDEkwvcPO5sWYrmHL6wEJZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NVMPnzAbsY61LLEJvPjSp80a7V637fkktNV7KUSsHpBKQQHoJB6Ml3RWG6VaPcrLO
         bskDLU+fROofHgH2unyoJv9RHrIBpqc6xpyvAn2VEOMt6TKp1/Sow8zAJXVrrTx1Z4
         v+oXXohVceMiGFzwRRIclAJDf+zXd/5wqg3nS4B0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Zhang <zhangpan26@huawei.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 054/110] drivers/hid/hid-multitouch.c: fix a possible null pointer access.
Date:   Thu, 30 Jan 2020 19:38:30 +0100
Message-Id: <20200130183621.535866519@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Zhang <zhangpan26@huawei.com>

[ Upstream commit 306d5acbfc66e7cccb4d8f91fc857206b8df80d1 ]

1002     if ((quirks & MT_QUIRK_IGNORE_DUPLICATES) && mt) {
1003         struct input_mt_slot *i_slot = &mt->slots[slotnum];
1004
1005         if (input_mt_is_active(i_slot) &&
1006             input_mt_is_used(mt, i_slot))
1007             return -EAGAIN;
1008     }

We previously assumed 'mt' could be null (see line 1002).

The following situation is similar, so add a judgement.

Signed-off-by: Pan Zhang <zhangpan26@huawei.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index f0d4172d51319..362805ddf3777 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1019,7 +1019,7 @@ static int mt_process_slot(struct mt_device *td, struct input_dev *input,
 		tool = MT_TOOL_DIAL;
 	else if (unlikely(!confidence_state)) {
 		tool = MT_TOOL_PALM;
-		if (!active &&
+		if (!active && mt &&
 		    input_mt_is_active(&mt->slots[slotnum])) {
 			/*
 			 * The non-confidence was reported for
-- 
2.20.1



