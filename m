Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A164C6537CC
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 21:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234653AbiLUUvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 15:51:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiLUUvE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 15:51:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587F81A805;
        Wed, 21 Dec 2022 12:51:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5CB360C98;
        Wed, 21 Dec 2022 20:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0257C433F0;
        Wed, 21 Dec 2022 20:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671655862;
        bh=XwvgmsAZzTsYMdW54Yg4aAguQi6qndDU8Dy5H3GxjRA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WlmhjcwDXxX3t7g5+nQi2Re9d4MqXg90gl/Bz3AZbe5aOmc4FmnZsc5KOqMYbtkqr
         sqLHcl1cFNk/+wRTiHG2OVoRjvGiZm56bthn/H7jSahErdR8ICOWuOlBlQjBpDlshq
         +fgnF+QUEge5MGUY+iosM00NP+FOhV2RTWYirmi8fIUf80qUS9wCFrVy/C69eMlwYg
         R/qiH44YKoXRlOHMnN1t6fwgi/GRWpePY9aTmuZgXoZzfKp0acoQCjT8isvKCHecNT
         C4sQ3BAg1keAUWjEBv45oJ/eppkpfgO972gyN/vZdOpiKg70GEU3l1EJETj9IQQ5ld
         g1+99RJ6CMoQw==
Date:   Wed, 21 Dec 2022 12:51:00 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc:     dhowells@redhat.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, zohar@linux.ibm.com,
        dmitry.kasatkin@gmail.com, paul@paul-moore.com, jmorris@namei.org,
        serge@hallyn.com, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 2/2] KEYS: asymmetric: Copy sig and digest in
 public_key_verify_signature()
Message-ID: <Y6NxtH41JNMy3NOl@sol.localdomain>
References: <20221221103710.2540276-1-roberto.sassu@huaweicloud.com>
 <20221221103710.2540276-2-roberto.sassu@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221221103710.2540276-2-roberto.sassu@huaweicloud.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 21, 2022 at 11:37:10AM +0100, Roberto Sassu wrote:
> +	sg_init_table(&src_sg, 1);
> +	sg_set_buf(&src_sg, buf, sig->s_size + sig->digest_size);

The above two function calls should be replaced with sg_init_one().

- Eric
