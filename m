Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11F577F32E
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405974AbfHBJyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:54:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406399AbfHBJyO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:54:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B19D2064A;
        Fri,  2 Aug 2019 09:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739653;
        bh=A6SMS4Td+ReUT+zVlgBmklIZhFxP34I6rbFV+0gXWoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fC9DsP7+W/wF6qWlMRL2MlcxL6SAk6wBj0T8TY/4ead+s95A5ZCy7GafJGHg2nbbt
         hY574BlAeuwkIGg2ac9kYTF9l2Fy/kCkje42HIlI4/DM97pdMwUVJ2Sx2OjsFdWAVY
         iZONX7mI68CkqxzisxtgYQJdt1XVeNE1d5SUGzzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Dmitry Safonov <dima@arista.com>
Subject: [PATCH 4.14 18/25] iommu/iova: Fix compilation error with !CONFIG_IOMMU_IOVA
Date:   Fri,  2 Aug 2019 11:39:50 +0200
Message-Id: <20190802092105.413174400@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092058.428079740@linuxfoundation.org>
References: <20190802092058.428079740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

commit 201c1db90cd643282185a00770f12f95da330eca upstream.

The stub function for !CONFIG_IOMMU_IOVA needs to be
'static inline'.

Fixes: effa467870c76 ('iommu/vt-d: Don't queue_iova() if there is no flush queue')
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/iova.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/iova.h
+++ b/include/linux/iova.h
@@ -235,7 +235,7 @@ static inline void init_iova_domain(stru
 {
 }
 
-bool has_iova_flush_queue(struct iova_domain *iovad)
+static inline bool has_iova_flush_queue(struct iova_domain *iovad)
 {
 	return false;
 }


