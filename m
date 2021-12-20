Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C58347B039
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239361AbhLTP2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239884AbhLTP2a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:28:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F73C09B077;
        Mon, 20 Dec 2021 06:52:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24D25611C9;
        Mon, 20 Dec 2021 14:52:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1F4C36AE8;
        Mon, 20 Dec 2021 14:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011935;
        bh=ELXh43Enl+VtzBXFgkpxLfUjGy4jui/skAiewd0Nolw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W3ZjhkHHHKUi2G982IkvPq9ExVhPj3oiMT2zr5eQ9BJZ0dTfQa6zclt2HGtQ1w5RB
         fUqLTb/mKx1vZo417RDd13gydwTp6ZIH05saexIyO/z0YiDLFYkJV/h2uyQQWJ9TPP
         3W4IaMmMRGCOnGRTHFnKDtYz/AuCnM+CArTKzhGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.15 021/177] vduse: check that offset is within bounds in get_config()
Date:   Mon, 20 Dec 2021 15:32:51 +0100
Message-Id: <20211220143040.792604724@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit dc1db0060c02d119fd4196924eff2d1129e9a442 upstream.

This condition checks "len" but it does not check "offset" and that
could result in an out of bounds read if "offset > dev->config_size".
The problem is that since both variables are unsigned the
"dev->config_size - offset" subtraction would result in a very high
unsigned value.

I think these checks might not be necessary because "len" and "offset"
are supposed to already have been validated using the
vhost_vdpa_config_validate() function.  But I do not know the code
perfectly, and I like to be safe.

Fixes: c8a6153b6c59 ("vduse: Introduce VDUSE - vDPA Device in Userspace")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20211208150956.GA29160@kili
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/vdpa_user/vduse_dev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -655,7 +655,8 @@ static void vduse_vdpa_get_config(struct
 {
 	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
 
-	if (len > dev->config_size - offset)
+	if (offset > dev->config_size ||
+	    len > dev->config_size - offset)
 		return;
 
 	memcpy(buf, dev->config + offset, len);


