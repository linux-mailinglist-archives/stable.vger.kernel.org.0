Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF68E566D93
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236971AbiGEMZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237672AbiGEMXr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:23:47 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2889B1F2CD;
        Tue,  5 Jul 2022 05:16:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 81890CE1A40;
        Tue,  5 Jul 2022 12:16:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B430C341C7;
        Tue,  5 Jul 2022 12:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023413;
        bh=kAGMnUVc6LIcq+Uu9PWZyrTEtni2EJpQWzRXb6E6r7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DzLc7vYLSYVQIGnglZUIiRx2WwOeUBofPAQvi4VhESBQxL88scc9A8hqvDd/Hs7Y0
         faJMaQb/UZwSpbpTiMY2l/i1dTIPQdQlBo0tvV2vNs6OP5n1f5Mn+bi9tWscrPIkac
         ifPTY7hcyaQ4IHOzJqYQgpIhzzvUPOxBfuPmvxWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.18 052/102] vdpa/mlx5: Update Control VQ callback information
Date:   Tue,  5 Jul 2022 13:58:18 +0200
Message-Id: <20220705115619.883641836@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

commit 40f2f3e94178d45e4ee6078effba2dfc76f6f5ba upstream.

The control VQ specific information is stored in the dedicated struct
mlx5_control_vq. When the callback is updated through
mlx5_vdpa_set_vq_cb(), make sure to update the control VQ struct.

Fixes: 5262912ef3cf ("vdpa/mlx5: Add support for control VQ and MAC setting")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Message-Id: <20220613075958.511064-1-elic@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1757,6 +1757,8 @@ static void mlx5_vdpa_set_vq_cb(struct v
 	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
 
 	ndev->event_cbs[idx] = *cb;
+	if (is_ctrl_vq_idx(mvdev, idx))
+		mvdev->cvq.event_cb = *cb;
 }
 
 static void mlx5_cvq_notify(struct vringh *vring)


