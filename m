Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8AF566CD5
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236133AbiGEMU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236804AbiGEMSP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:18:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7704B1A040;
        Tue,  5 Jul 2022 05:13:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD41AB817D3;
        Tue,  5 Jul 2022 12:13:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1A9C341C7;
        Tue,  5 Jul 2022 12:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023217;
        bh=fc03KRv4n05doHcwdHMzyIPbV+2wmIbCP3pcCivNDTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VX+lNMgz9EigBGo67j9SyrQK/VBsWcDjn/miS0iSmgChR3upELJ1S2lUupASZte8m
         lekcRr2ulFL1LXIkdrMkIDjQRiu41sgKFU3j57YIG3ey8SNyR6QNgBX2Qswre/t9QN
         cycfsDsEBM9/ov/hZZCaBfZ19e2AipGXxU+nHOms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.15 38/98] vdpa/mlx5: Update Control VQ callback information
Date:   Tue,  5 Jul 2022 13:57:56 +0200
Message-Id: <20220705115618.671566885@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
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
@@ -1698,6 +1698,8 @@ static void mlx5_vdpa_set_vq_cb(struct v
 	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
 
 	ndev->event_cbs[idx] = *cb;
+	if (is_ctrl_vq_idx(mvdev, idx))
+		mvdev->cvq.event_cb = *cb;
 }
 
 static void mlx5_cvq_notify(struct vringh *vring)


