Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97A235F29BB
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbiJCHYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbiJCHXn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:23:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B324AD6F;
        Mon,  3 Oct 2022 00:17:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B50CCB80E7B;
        Mon,  3 Oct 2022 07:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20716C433C1;
        Mon,  3 Oct 2022 07:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781453;
        bh=nLcfUt/LczRYhf4bCTzFSuUX5SXmRIwKX2n/XDarK+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KkZgw8JTJUYAIvR3XAtIM2VdsrwFGrG8FrzW9STIEWlfJxdrO9cbBFk1WV5qYPRMC
         6J3Zl7z7DDeNoupe6T7o+hW6M22h6aUPMT7ot6GJBhWPPl3YOjjbH1dwgRyYbfFNc8
         s50j8jvmq+i1voDmn08W9zShnhwiFd+5rAGZ3sww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        Maxime Coquelin <maxime.coquelin@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH 5.15 25/83] vduse: prevent uninitialized memory accesses
Date:   Mon,  3 Oct 2022 09:10:50 +0200
Message-Id: <20221003070722.625602921@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Coquelin <maxime.coquelin@redhat.com>

commit 46f8a29272e51b6df7393d58fc5cb8967397ef2b upstream.

If the VDUSE application provides a smaller config space
than the driver expects, the driver may use uninitialized
memory from the stack.

This patch prevents it by initializing the buffer passed by
the driver to store the config value.

This fix addresses CVE-2022-2308.

Cc: stable@vger.kernel.org # v5.15+
Fixes: c8a6153b6c59 ("vduse: Introduce VDUSE - vDPA Device in Userspace")
Reviewed-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Maxime Coquelin <maxime.coquelin@redhat.com>
Message-Id: <20220831154923.97809-1-maxime.coquelin@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/vdpa_user/vduse_dev.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -655,10 +655,15 @@ static void vduse_vdpa_get_config(struct
 {
 	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
 
-	if (offset > dev->config_size ||
-	    len > dev->config_size - offset)
+	/* Initialize the buffer in case of partial copy. */
+	memset(buf, 0, len);
+
+	if (offset > dev->config_size)
 		return;
 
+	if (len > dev->config_size - offset)
+		len = dev->config_size - offset;
+
 	memcpy(buf, dev->config + offset, len);
 }
 


