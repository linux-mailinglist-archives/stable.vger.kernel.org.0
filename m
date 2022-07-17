Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA8775775CE
	for <lists+stable@lfdr.de>; Sun, 17 Jul 2022 12:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiGQKwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jul 2022 06:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGQKwE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jul 2022 06:52:04 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334E913DEE;
        Sun, 17 Jul 2022 03:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=WYi/qNyaZufNs0i6DbcSRbqr7NgmOtWvT8f/uUZqRXg=;
        t=1658055123; x=1659264723; b=SBWDeWSKy3/wa8YNxhnnw/7uvV6NpGlx2IYCzFqFAo611+o
        l4rN3B8MNt2XOCax9J6UoZWY+ckI6d6tf2pPM3F8d5h3vemfBhQxTCh8e3r8Xa1eebleKL3W0yyQm
        G+eWGwvN6ctq0fkZj0lKzQ+Vbyu+b9JlUJH+XD7f58OobSgsLjWWJ12cqX0QDYsbqhRJ9FGEMRLEA
        dFthetJ8z7zq1aIO83Gqxywo5zJv8ERg1mxDkFC3j6Q9rr5xJNZDplYOSjQLxlPG45r4+bq4Sp3HO
        TdWYe8d/n340tTiT2/asjnPXDoj90frflg29KwqV6Xl1RWcYpT4DWN1icC9r/14w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oD1sV-000hUE-1N;
        Sun, 17 Jul 2022 12:51:59 +0200
Message-ID: <3a03bc428ebc5741494a3e05ee98f55be2bdd3ec.camel@sipsolutions.net>
Subject: Re: [PATCH v4] um: seed rng using host OS rng
From:   Johannes Berg <johannes@sipsolutions.net>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-um@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>
Date:   Sun, 17 Jul 2022 12:51:58 +0200
In-Reply-To: <20220717105051.1539173-1-Jason@zx2c4.com>
References: <20220717084652.1525087-1-Jason@zx2c4.com>
         <20220717105051.1539173-1-Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 2022-07-17 at 12:50 +0200, Jason A. Donenfeld wrote:
> UML generally does not provide access to special CPU instructions like
> RDRAND, and execution tends to be rather deterministic, with no real
> hardware interrupts, making good randomness really very hard, if not
> all together impossible. Not only is this a security eyebrow raiser, but
> it's also quite annoying when trying to do various pieces of UML-based
> automation that takes a long time to boot, if ever.
>=20
> Fix this by trivially calling getrandom() in the host and using that
> seed as "bootloader randomness", which initializes the rng immediately
> at UML boot.
>=20
> The old behavior can be restored the same way as on any other arch, by
> way of CONFIG_TRUST_BOOTLOADER_RANDOMNESS=3Dn or
> random.trust_bootloader=3D0. So seen from that perspective, this just
> makes UML act like other archs, which is positive in its own right.
>=20
> Additionally, wire up arch_get_random_{int,long}() in the same way, so
> that reseeds can also make use of the host RNG, controllable by
> CONFIG_TRUST_CPU_RANDOMNESS and random.trust_cpu, per usual.
>=20
> Cc: stable@vger.kernel.org
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Acked-By: Anton Ivanov <anton.ivanov@cambridgegreys.com>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> Johannes - I need to take this through random.git, because it relies on
> some other changes living there. Is that okay with you? -Jason

Sure, go ahead, thanks for doing this work!

> Changes v3->v4:
> - Don't include os.h, per Johannes' suggestion.

Thanks.

Acked-by: Johannes Berg <johannes@sipsolutions.net>


johannes
