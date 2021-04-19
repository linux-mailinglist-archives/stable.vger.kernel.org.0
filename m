Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9B5364C11
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 22:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243123AbhDSUsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 16:48:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241004AbhDSUq3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 16:46:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61C4A613ED;
        Mon, 19 Apr 2021 20:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865121;
        bh=OA8tR/JWbVQiO1aagRDO5aGsUKFVD4bCapNzA312gwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R7CzLvQHZ1iCpLg6A/SRxdN6R/KDbkxNZ7FfDVOQkzZIvN2Z0XS7Q2PYhxBtNVpdL
         3Vk801yufo4TmWI3N+ZPNK0wdN1An2J350xokc4uy8l67IfiT3c6L4m22wOYdU6od0
         apKAmZmimVugkytQY3tAcJ4OE311g+HqrQW3Sh6PE50EdGpIh3EU7npZqeNudSNS41
         d5JWEONd/xeRwERql/RDB7ONHtri21OviSVfuGBlbH9HjJeyC2ZhQyv+CWFSINSEEQ
         IZpo1D90lrYHzlud3iIoq4v9O+0LXGrlxK0uB7Zx31HNMorA2CkByUN9G+LKystYfk
         081DpxwUqxWWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/12] HID: alps: fix error return code in alps_input_configured()
Date:   Mon, 19 Apr 2021 16:45:07 -0400
Message-Id: <20210419204517.6770-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204517.6770-1-sashal@kernel.org>
References: <20210419204517.6770-1-sashal@kernel.org>
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
index f4cf541d13e0..3eddd8f73b57 100644
--- a/drivers/hid/hid-alps.c
+++ b/drivers/hid/hid-alps.c
@@ -766,6 +766,7 @@ static int alps_input_configured(struct hid_device *hdev, struct hid_input *hi)
 
 		if (input_register_device(data->input2)) {
 			input_free_device(input2);
+			ret = -ENOENT;
 			goto exit;
 		}
 	}
-- 
2.30.2

