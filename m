Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6ACF364C69
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 22:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242875AbhDSUum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 16:50:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243124AbhDSUsb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 16:48:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70368613B8;
        Mon, 19 Apr 2021 20:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865157;
        bh=EDj1gHlZSzYdYf98LrWwBli/46xSjlYyncHL60ccxE8=;
        h=From:To:Cc:Subject:Date:From;
        b=Gfi9BDNqg3bFiiDYn6at6yfZIY0um2cP05TBgXNpefOHsShPOhVcHtY2KrikMipcT
         19zsFoyA8AeW+1+BvL08Gh7T/LcTmEC1DRfDYrzMs8e6qVQrsuppegAYxI0JtqXt5d
         eYuxpB7FrJppc9g8HwfQyuWh1k5F57mC1E5JrNgQIYimW8gFJhb4X2wsWeOOrYG1Ru
         J2YvZKTrKOg4PHKELB9xul+4ou+6PPMKu1Oy1wJNFoIVFj5tpdtFDi5JtQYwRNaVEH
         eRH/12UPQyfLTfVTjkgdpDB0uzOKDK6h1m6qwSyr96uzbijBGzDEmGBD7lFJVvtfqV
         +h/dlN6aFNN7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 1/8] HID: alps: fix error return code in alps_input_configured()
Date:   Mon, 19 Apr 2021 16:45:47 -0400
Message-Id: <20210419204554.7071-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
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

