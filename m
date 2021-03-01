Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE77D3288E1
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237605AbhCARq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:46:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:59902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238300AbhCARlg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:41:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 043DB650C7;
        Mon,  1 Mar 2021 16:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617819;
        bh=6Lm7od1aKbbyJ1KHNdbpxeA0fy8Gjnul/9RmhsGCtnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hcCTHebBYRkqY91T29jXMzc7sBRyCYJYzHlN8lDG9m+3a7qdeZ+Abk3aUCXcDFytj
         EdF2FrwMi2r0RBvDdoov6uCsnlYgOf7tU+F2dAHOLNSr3ndLm7yxbk45DfORPJiJdq
         jIYfmR6TLICjteNSIOE8pNjFRE41tYKycE5fH1lM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 208/340] mei: hbm: call mei_set_devstate() on hbm stop response
Date:   Mon,  1 Mar 2021 17:12:32 +0100
Message-Id: <20210301161058.539452390@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

[ Upstream commit 3a77df62deb2e62de0dc26c1cb763cc152329287 ]

Use mei_set_devstate() wrapper upon hbm stop command response,
to trigger sysfs event.

Fixes: 43b8a7ed4739 ("mei: expose device state in sysfs")
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20210129120752.850325-3-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/hbm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index a44094cdbc36c..d20b2b99c6f24 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -1300,7 +1300,7 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 			return -EPROTO;
 		}
 
-		dev->dev_state = MEI_DEV_POWER_DOWN;
+		mei_set_devstate(dev, MEI_DEV_POWER_DOWN);
 		dev_info(dev->dev, "hbm: stop response: resetting.\n");
 		/* force the reset */
 		return -EPROTO;
-- 
2.27.0



