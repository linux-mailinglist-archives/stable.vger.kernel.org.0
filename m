Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A791157BF5
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbgBJNdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:33:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:52962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727990AbgBJMfe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:34 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD77E2168B;
        Mon, 10 Feb 2020 12:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338132;
        bh=5TL30PjowtXTYNPP0SZ29e3wn97dh7wA6dQ0mz7WZXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L62iBchp8dSOptmt4o0xzwVZ2t80hazIV6fKYvqNfV4hVJcjb3ng3cguqeSLn+c0n
         gti3IEu+RVHyxG2RdWwYZx1CSg2XZGfIXpV09qkeFaVpLqTAtRMa54vLoDwEohgZUg
         rJfIgfjzwhvAuif7aJYjsf1mwf0dmSVkL54bgxw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helen Koike <helen.koike@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.19 042/195] media: v4l2-rect.h: fix v4l2_rect_map_inside() top/left adjustments
Date:   Mon, 10 Feb 2020 04:31:40 -0800
Message-Id: <20200210122310.410412341@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helen Koike <helen.koike@collabora.com>

commit f51e50db4c20d46930b33be3f208851265694f3e upstream.

boundary->width and boundary->height are sizes relative to
boundary->left and boundary->top coordinates, but they were not being
taken into consideration to adjust r->left and r->top, leading to the
following error:

Consider the follow as initial values for boundary and r:

struct v4l2_rect boundary = {
	.left = 100,
	.top = 100,
	.width = 800,
	.height = 600,
}

struct v4l2_rect r = {
	.left = 0,
	.top = 0,
	.width = 1920,
	.height = 960,
}

calling v4l2_rect_map_inside(&r, &boundary) was modifying r to:

r = {
	.left = 0,
	.top = 0,
	.width = 800,
	.height = 600,
}

Which is wrongly outside the boundary rectangle, because:

	v4l2_rect_set_max_size(r, boundary); // r->width = 800, r->height = 600
	...
	if (r->left + r->width > boundary->width) // true
		r->left = boundary->width - r->width; // r->left = 800 - 800
	if (r->top + r->height > boundary->height) // true
		r->top = boundary->height - r->height; // r->height = 600 - 600

Fix this by considering top/left coordinates from boundary.

Fixes: ac49de8c49d7 ("[media] v4l2-rect.h: new header with struct v4l2_rect helper functions")
Signed-off-by: Helen Koike <helen.koike@collabora.com>
Cc: <stable@vger.kernel.org>      # for v4.7 and up
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/media/v4l2-rect.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/media/v4l2-rect.h
+++ b/include/media/v4l2-rect.h
@@ -63,10 +63,10 @@ static inline void v4l2_rect_map_inside(
 		r->left = boundary->left;
 	if (r->top < boundary->top)
 		r->top = boundary->top;
-	if (r->left + r->width > boundary->width)
-		r->left = boundary->width - r->width;
-	if (r->top + r->height > boundary->height)
-		r->top = boundary->height - r->height;
+	if (r->left + r->width > boundary->left + boundary->width)
+		r->left = boundary->left + boundary->width - r->width;
+	if (r->top + r->height > boundary->top + boundary->height)
+		r->top = boundary->top + boundary->height - r->height;
 }
 
 /**


