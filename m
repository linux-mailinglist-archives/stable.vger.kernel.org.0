Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF49417473
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346398AbhIXNGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:06:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345840AbhIXNEM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:04:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DE746137F;
        Fri, 24 Sep 2021 12:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488118;
        bh=esx5c0VZwR5t3FBXNz4g2zBcWplPYfDtSj0yiaJktnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y2Ry7yPjxhdae5w6iO+wKCqpnTG7/8T6I3/8bx42LoYRGzRFBmGxzjIQqPGMskAen
         F3bxZVyCngcQa8ZV9fFQZjimcwJWJconKTvVAuYdc7RN0ArVzmpsbFRJhNX6yt0O0z
         76V+YqvlzEkbscqxUgGJ83UZr9JvFYk+JoRDepyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 091/100] nvmet: fixup buffer overrun in nvmet_subsys_attr_serial()
Date:   Fri, 24 Sep 2021 14:44:40 +0200
Message-Id: <20210924124344.531888631@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit f04064814c2a15c22ed9c803f9b634ef34f91092 ]

The serial number is copied into the buffer via memcpy_and_pad()
with the length NVMET_SN_MAX_SIZE. So when printing out we also
need to take just that length as anything beyond that will be
uninitialized.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/configfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 273555127188..fa88bf9cba4d 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -1067,7 +1067,8 @@ static ssize_t nvmet_subsys_attr_serial_show(struct config_item *item,
 {
 	struct nvmet_subsys *subsys = to_subsys(item);
 
-	return snprintf(page, PAGE_SIZE, "%s\n", subsys->serial);
+	return snprintf(page, PAGE_SIZE, "%*s\n",
+			NVMET_SN_MAX_SIZE, subsys->serial);
 }
 
 static ssize_t
-- 
2.33.0



