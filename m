Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABF204F3154
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355744AbiDEKVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347393AbiDEJ0M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:26:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7673C9682D;
        Tue,  5 Apr 2022 02:15:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5694861576;
        Tue,  5 Apr 2022 09:15:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61FA4C385A0;
        Tue,  5 Apr 2022 09:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150110;
        bh=uJf7pj87pn7mUSWMH3sAg8R4hUfURYzVn3VcFRGN990=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V1C4j26T7gnyJA8QLDh/4cv3NGCO3yyQKF66ikTrb/JGvxI7D9ZEQtjo7Z24E/AGy
         JFSF4CmTVRtqN4N7HWlPWTmiSxR16dfjSWvMCIu1T8924kr2eSR0Alk51UEB8c0/Ix
         kZMUhgECtqe399Urav8e7ojDHy+5NKLZRVLo8WK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anirudh Rayabharam <mail@anirudhrb.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH 5.16 0956/1017] vhost: handle error while adding split ranges to iotlb
Date:   Tue,  5 Apr 2022 09:31:09 +0200
Message-Id: <20220405070422.586330529@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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


