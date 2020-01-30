Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C01214E1F4
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731157AbgA3Srn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:47:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:58386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730976AbgA3Srl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:47:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34CB324687;
        Thu, 30 Jan 2020 18:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580410059;
        bh=qwX7KzfDO8n1SQ9JfC+x1esOcYl8z/Z/tv967FPO1jA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s9U5RL5hXNltH1ZMST36Qqpnxg9PYE8qCwPno5TJ8sfQBqFcbRVZMlI1N6t4PTb00
         MmjXG7zAp/DPsI2OmY3vav23OdLUnrrrglXb2t/UZIyHfv7kmPWXlqmsGx3EEKVWux
         eR+zBECqw+IFctLwRrw+9BNRq4JKDj+Houpn6Ycw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Zhang <zhangpan26@huawei.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 30/55] drivers/hid/hid-multitouch.c: fix a possible null pointer access.
Date:   Thu, 30 Jan 2020 19:39:11 +0100
Message-Id: <20200130183614.135099635@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.563083888@linuxfoundation.org>
References: <20200130183608.563083888@linuxfoundation.org>
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
index 8403251992abb..19dfd8acd0dab 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1007,7 +1007,7 @@ static int mt_process_slot(struct mt_device *td, struct input_dev *input,
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



