Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2E75584BA
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiFWRtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235245AbiFWRro (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:47:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2213FA14BD;
        Thu, 23 Jun 2022 10:11:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DF85B824B6;
        Thu, 23 Jun 2022 17:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A41CC3411B;
        Thu, 23 Jun 2022 17:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004257;
        bh=+3Vb5uCzVRbG+5aje9N5PGNINbJuKtDLlWJr/AUROAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oR8K8KAcqFAtXGoUP656ObhjeGGAM5nfSff60b9hq6vJTKDim4lAGUogN56bbYAy+
         kTFb5t1FIyxBoyO54cfGdiIkHIjGMWCSJxNY8RxPT50lEk+HYUEWOMaPsyKCrIQGL8
         Wu7TuLa0j4VP5ZrJyS1H86UkSofq2GrkX5R0eqGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Murilo Opsfelder Araujo <muriloo@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.14 226/237] virtio-pci: Remove wrong address verification in vp_del_vqs()
Date:   Thu, 23 Jun 2022 18:44:20 +0200
Message-Id: <20220623164349.653871343@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Murilo Opsfelder Araujo <muriloo@linux.ibm.com>

commit 7e415282b41bf0d15c6e0fe268f822d9b083f2f7 upstream.

GCC 12 enhanced -Waddress when comparing array address to null [0],
which warns:

    drivers/virtio/virtio_pci_common.c: In function ‘vp_del_vqs’:
    drivers/virtio/virtio_pci_common.c:257:29: warning: the comparison will always evaluate as ‘true’ for the pointer operand in ‘vp_dev->msix_affinity_masks + (sizetype)((long unsigned int)i * 256)’ must not be NULL [-Waddress]
      257 |                         if (vp_dev->msix_affinity_masks[i])
          |                             ^~~~~~

In fact, the verification is comparing the result of a pointer
arithmetic, the address "msix_affinity_masks + i", which will always
evaluate to true.

Under the hood, free_cpumask_var() calls kfree(), which is safe to pass
NULL, not requiring non-null verification.  So remove the verification
to make compiler happy (happy compiler, happy life).

[0] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=102103

Signed-off-by: Murilo Opsfelder Araujo <muriloo@linux.ibm.com>
Message-Id: <20220415023002.49805-1-muriloo@linux.ibm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Christophe de Dinechin <dinechin@redhat.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virtio/virtio_pci_common.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -256,8 +256,7 @@ void vp_del_vqs(struct virtio_device *vd
 
 	if (vp_dev->msix_affinity_masks) {
 		for (i = 0; i < vp_dev->msix_vectors; i++)
-			if (vp_dev->msix_affinity_masks[i])
-				free_cpumask_var(vp_dev->msix_affinity_masks[i]);
+			free_cpumask_var(vp_dev->msix_affinity_masks[i]);
 	}
 
 	if (vp_dev->msix_enabled) {


