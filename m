Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B88364BDC
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 22:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242782AbhDSUq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 16:46:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242612AbhDSUph (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 16:45:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8187E613AB;
        Mon, 19 Apr 2021 20:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865098;
        bh=bULdcyXrCo7E1DtG+Eqo2f5vW2vgbbzbBhwmacpqDhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oZ57HVBuvPmDaAcEsZ4RIa4OFoD+tqWVjx78MaVZIfk21UEDTBuOJcSxVwYv0wQAt
         6CMjV6zGCwH681R5iBoG0dZPT22Lmnq3SDqf4TNk/LFpte0/ToYPLz1UjoT7S7ppli
         JSeFS9EdqP1BTtNnkf0m38gMFhQr2A8eOAIgmHRS1jQYGF3Rpgw0UmIBMJf58jZvAq
         VhjVvrUZrvDzQakKQwhn6bR87Svj2rnoWainHycL2gBkw8J/h6EH56mJ+9Wf/IGx4j
         lJHxxojLhQN4HAaQ2wDd2xKWOjQR5yRSg0PPM5/fxRHk/KvHxaggz+WeMpLVJoTgkI
         lw7itv3UzpHXA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 02/14] HID: alps: fix error return code in alps_input_configured()
Date:   Mon, 19 Apr 2021 16:44:42 -0400
Message-Id: <20210419204454.6601-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204454.6601-1-sashal@kernel.org>
References: <20210419204454.6601-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit fa8ba6e5dc0e78e409e503ddcfceef5dd96527f4 ]

When input_register_device() fails, no error return code is assigned.
To fix this bug, ret is assigned with -ENOENT as error return code.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-alps.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-alps.c b/drivers/hid/hid-alps.c
index d33f5abc8f64..2477b2a3f7c3 100644
--- a/drivers/hid/hid-alps.c
+++ b/drivers/hid/hid-alps.c
@@ -762,6 +762,7 @@ static int alps_input_configured(struct hid_device *hdev, struct hid_input *hi)
 
 		if (input_register_device(data->input2)) {
 			input_free_device(input2);
+			ret = -ENOENT;
 			goto exit;
 		}
 	}
-- 
2.30.2

