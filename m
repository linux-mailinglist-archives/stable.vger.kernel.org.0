Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F592531611
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239815AbiEWRNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240193AbiEWRLq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:11:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532E310A4;
        Mon, 23 May 2022 10:11:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1F8B61507;
        Mon, 23 May 2022 17:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7AB8C385A9;
        Mon, 23 May 2022 17:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325873;
        bh=VXtcAqn6/M6grVmBFWvrRlt1YfHPvmVTbARNuX4JhIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=piDoXEo54M1KxdfCC6Z4V6qNj+FfE4HrpG0CfvpZyqsIv4z1knTOexyqmArHbYQRq
         b2jh1XQIqGdPusiDj/jPPm1CLBxuLp3gaqlBhdtjOR0WgqBjQvF4Z0ak7s0iIVkQYk
         /Nl4oEyRdeRx06kPM2RF6xPV3eDchSZnbABf8Tjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>,
        Brian Masney <bmasney@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 15/44] crypto: qcom-rng - fix infinite loop on requests not multiple of WORD_SZ
Date:   Mon, 23 May 2022 19:04:59 +0200
Message-Id: <20220523165756.026136368@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165752.797318097@linuxfoundation.org>
References: <20220523165752.797318097@linuxfoundation.org>
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
 


