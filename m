Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61974364B54
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 22:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242239AbhDSUoW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 16:44:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240041AbhDSUoT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 16:44:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBC25611C9;
        Mon, 19 Apr 2021 20:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865028;
        bh=1H3mngB1wziDnZrSCLkVf32m5DqRuWUfzlvhLfR7xXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aA6FW5Pdd7UqnvHZWoyR7kHegojgLsojYWh43VqUTxxNXm5g2XF5rrH/BYfoJLckR
         9bvqn/dGrNAvK5XO2M4X6xkz9wfnGnjQgSTbAujmJpg5Dr3k/4azWa+UI/P3Y8kR2j
         lP7ztQxADYy4K6RJuisUvmYK7Ij8YDT3nPXJg9bGrqky79VWSW4HtKz6Xy724Ejjxu
         fZpNC4Kmf3xCDQVMcsOkE9y2c33PmINeINKveFYMf26IyWO7lyvRfXR0vxxX+Z+2LT
         rOYMYCl0uspsFU2SBjBgvmYBb0dBqgIT8korKssGIUv3b3fRGMvB/a7lUTX1q8hK4u
         /yWyoHWKUcYng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 03/23] HID: alps: fix error return code in alps_input_configured()
Date:   Mon, 19 Apr 2021 16:43:22 -0400
Message-Id: <20210419204343.6134-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204343.6134-1-sashal@kernel.org>
References: <20210419204343.6134-1-sashal@kernel.org>
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
index 3feaece13ade..6b665931147d 100644
--- a/drivers/hid/hid-alps.c
+++ b/drivers/hid/hid-alps.c
@@ -761,6 +761,7 @@ static int alps_input_configured(struct hid_device *hdev, struct hid_input *hi)
 
 		if (input_register_device(data->input2)) {
 			input_free_device(input2);
+			ret = -ENOENT;
 			goto exit;
 		}
 	}
-- 
2.30.2

