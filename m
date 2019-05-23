Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38460288AB
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391017AbfEWT14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:27:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391671AbfEWT1x (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:27:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D85720879;
        Thu, 23 May 2019 19:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639672;
        bh=R4z72mLKfM2fz0ZjlVUj+eqeS+fwJHDSCzafb5yl/Y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TSZudQToHg4rNCbFGr4hw8YKJWnNZbdd42kyndVB+c+O2Fwo4ECs7pGfnLz/OPFBv
         ute6yynA33HvXFdUZgVATqu0XbTsu6qUux9MxvAS1OP6a8Czr154LMQnaCYaY/yCww
         uDJmoLNrvS2XfOtmzEsIEhyfBXjpnotYPW7OfW9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 5.1 052/122] media: imx: Clear fwnode link struct for each endpoint iteration
Date:   Thu, 23 May 2019 21:06:14 +0200
Message-Id: <20190523181711.614068954@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve Longerbeam <slongerbeam@gmail.com>

commit 107927fa597c99eaeee4f51865ca0956ec71b6a2 upstream.

In imx_media_create_csi_of_links(), the 'struct v4l2_fwnode_link' must
be cleared for each endpoint iteration, otherwise if the remote port
has no "reg" property, link.remote_port will not be reset to zero.
This was discovered on the i.MX53 SMD board, since the OV5642 connects
directly to ipu1_csi0 and has a single source port with no "reg"
property.

Fixes: 621b08eabcddb ("media: staging/imx: remove static media link arrays")

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/media/imx/imx-media-of.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/staging/media/imx/imx-media-of.c
+++ b/drivers/staging/media/imx/imx-media-of.c
@@ -145,15 +145,18 @@ int imx_media_create_csi_of_links(struct
 				  struct v4l2_subdev *csi)
 {
 	struct device_node *csi_np = csi->dev->of_node;
-	struct fwnode_handle *fwnode, *csi_ep;
-	struct v4l2_fwnode_link link;
 	struct device_node *ep;
-	int ret;
-
-	link.local_node = of_fwnode_handle(csi_np);
-	link.local_port = CSI_SINK_PAD;
 
 	for_each_child_of_node(csi_np, ep) {
+		struct fwnode_handle *fwnode, *csi_ep;
+		struct v4l2_fwnode_link link;
+		int ret;
+
+		memset(&link, 0, sizeof(link));
+
+		link.local_node = of_fwnode_handle(csi_np);
+		link.local_port = CSI_SINK_PAD;
+
 		csi_ep = of_fwnode_handle(ep);
 
 		fwnode = fwnode_graph_get_remote_endpoint(csi_ep);


