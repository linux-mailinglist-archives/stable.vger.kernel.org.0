Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC17B4F314C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237785AbiDEInX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241105AbiDEIct (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F07D15725;
        Tue,  5 Apr 2022 01:27:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 249EAB81BCE;
        Tue,  5 Apr 2022 08:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7C4C385A1;
        Tue,  5 Apr 2022 08:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147255;
        bh=uJf7pj87pn7mUSWMH3sAg8R4hUfURYzVn3VcFRGN990=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uq9aXLAOJU8VzPgGX8kLwL6x92z0W4f4lkk6ipm4dfoTl2lhHgMJnJSL2yOYih3Dh
         EnN58g5K4WAbvLtieaydxteapWcz+YxWqvI/MZACdz2/EZTW04JTACcaF7+blL1A1t
         5bT2wjl/jsYDijRBtaJwEotk6v7yV1CWFAtYqChI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anirudh Rayabharam <mail@anirudhrb.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH 5.17 1059/1126] vhost: handle error while adding split ranges to iotlb
Date:   Tue,  5 Apr 2022 09:30:06 +0200
Message-Id: <20220405070438.547533965@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anirudh Rayabharam <mail@anirudhrb.com>

commit 03a91c9af2c42ae14afafb829a4b7e6589ab5892 upstream.

vhost_iotlb_add_range_ctx() handles the range [0, ULONG_MAX] by
splitting it into two ranges and adding them separately. The return
value of adding the first range to the iotlb is currently ignored.
Check the return value and bail out in case of an error.

Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
Link: https://lore.kernel.org/r/20220312141121.4981-1-mail@anirudhrb.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Fixes: e2ae38cf3d91 ("vhost: fix hung thread due to erroneous iotlb entries")
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/iotlb.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/vhost/iotlb.c
+++ b/drivers/vhost/iotlb.c
@@ -62,8 +62,12 @@ int vhost_iotlb_add_range_ctx(struct vho
 	 */
 	if (start == 0 && last == ULONG_MAX) {
 		u64 mid = last / 2;
+		int err = vhost_iotlb_add_range_ctx(iotlb, start, mid, addr,
+				perm, opaque);
+
+		if (err)
+			return err;
 
-		vhost_iotlb_add_range_ctx(iotlb, start, mid, addr, perm, opaque);
 		addr += mid + 1;
 		start = mid + 1;
 	}


