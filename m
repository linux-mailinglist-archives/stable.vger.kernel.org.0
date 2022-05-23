Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 591C0531A86
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240442AbiEWRTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240429AbiEWRRj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:17:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1B4532CA;
        Mon, 23 May 2022 10:17:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA875614EB;
        Mon, 23 May 2022 17:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E96C385A9;
        Mon, 23 May 2022 17:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326124;
        bh=VXtcAqn6/M6grVmBFWvrRlt1YfHPvmVTbARNuX4JhIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WBBIo5eXAdIoTob0jt8DTy/pFv4ATL0gSs/AUu14LG2ID3dxIyIbRc3Xhpv1GYLeJ
         +S4Y2wBxzmZRxixb8psOCG+9gijiqzcrqaqGebhxcoVMTLHTh+kzxaggYJ6PiswntF
         uGLOQ94oRYnZBRQdtWfyB8HSPoPx0lLE0GWu2jTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>,
        Brian Masney <bmasney@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 31/68] crypto: qcom-rng - fix infinite loop on requests not multiple of WORD_SZ
Date:   Mon, 23 May 2022 19:04:58 +0200
Message-Id: <20220523165807.782143812@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165802.500642349@linuxfoundation.org>
References: <20220523165802.500642349@linuxfoundation.org>
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
@@ -64,6 +64,7 @@ static int qcom_rng_read(struct qcom_rng
 		} else {
 			/* copy only remaining bytes */
 			memcpy(data, &val, max - currsize);
+			break;
 		}
 	} while (currsize < max);
 


