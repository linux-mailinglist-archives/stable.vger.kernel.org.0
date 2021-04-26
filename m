Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B12336ADAE
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbhDZHhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:37:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232700AbhDZHhQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:37:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 152F7613C9;
        Mon, 26 Apr 2021 07:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422504;
        bh=EDj1gHlZSzYdYf98LrWwBli/46xSjlYyncHL60ccxE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R2327fmRoylbCzmGcUKQCOLW5mH9bqcnfCsoE497KPCFQbqu8svX4MbO0WQdzbW9y
         EdGOusUQ9T2tF9J8dEVJUqRXwXzfb5O9b0JZhUSa2nrtMxvWbvU1H9I8Pw4RvT71qr
         WM+G9lHZzrivMeSnTF0t7lT5qB+cv8qWSKSszLXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 40/49] HID: alps: fix error return code in alps_input_configured()
Date:   Mon, 26 Apr 2021 09:29:36 +0200
Message-Id: <20210426072821.089287977@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072819.721586742@linuxfoundation.org>
References: <20210426072819.721586742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ed9c0ea5b026..1bc6ad0339d2 100644
--- a/drivers/hid/hid-alps.c
+++ b/drivers/hid/hid-alps.c
@@ -429,6 +429,7 @@ static int alps_input_configured(struct hid_device *hdev, struct hid_input *hi)
 		ret = input_register_device(data->input2);
 		if (ret) {
 			input_free_device(input2);
+			ret = -ENOENT;
 			goto exit;
 		}
 	}
-- 
2.30.2



