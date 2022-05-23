Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4B9A531C9B
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241529AbiEWRdk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241854AbiEWRb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:31:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8240644D8;
        Mon, 23 May 2022 10:26:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 028E660916;
        Mon, 23 May 2022 17:26:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0564EC385A9;
        Mon, 23 May 2022 17:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326815;
        bh=bJzOwjF3X17Jgfd2o6J6v0+niskXRCoLjBovkKW+Lx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZOtMTRDK6Pbp0GT1ttvQZ4el8UJYAFQGTW5tx2DL4lvqnccXnPK0SVLZ4KiDqM4Ij
         aztPVB7wO3pEs8r30ThTHDjyhSu/ao0GaKaQo9kZqRxvf22dTjF52w6GO8T4EZeN65
         cWzi1WiBAkzo4tZ9EGf0nx33cwhABb2oauFqjxwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>,
        Brian Masney <bmasney@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.17 060/158] crypto: qcom-rng - fix infinite loop on requests not multiple of WORD_SZ
Date:   Mon, 23 May 2022 19:03:37 +0200
Message-Id: <20220523165840.778467821@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
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

From: Ondrej Mosnacek <omosnace@redhat.com>

commit 16287397ec5c08aa58db6acf7dbc55470d78087d upstream.

The commit referenced in the Fixes tag removed the 'break' from the else
branch in qcom_rng_read(), causing an infinite loop whenever 'max' is
not a multiple of WORD_SZ. This can be reproduced e.g. by running:

    kcapi-rng -b 67 >/dev/null

There are many ways to fix this without adding back the 'break', but
they all seem more awkward than simply adding it back, so do just that.

Tested on a machine with Qualcomm Amberwing processor.

Fixes: a680b1832ced ("crypto: qcom-rng - ensure buffer for generate is completely filled")
Cc: stable@vger.kernel.org
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/qcom-rng.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/crypto/qcom-rng.c
+++ b/drivers/crypto/qcom-rng.c
@@ -65,6 +65,7 @@ static int qcom_rng_read(struct qcom_rng
 		} else {
 			/* copy only remaining bytes */
 			memcpy(data, &val, max - currsize);
+			break;
 		}
 	} while (currsize < max);
 


