Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20AE15A9540
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 12:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233328AbiIAK6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 06:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234321AbiIAK6b (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 06:58:31 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F82A4B17
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 03:58:31 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id z8so13242659edb.6
        for <stable@vger.kernel.org>; Thu, 01 Sep 2022 03:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=cP4NBM0ETOYFq+TZhV3HDz5qwb6s5UdYnKys12wd3oA=;
        b=ZqrP13Zm47ZNVk4pP620bBwfOofAMBWqoDzQ/7naOs3U0MmZFunXAITeJ3Is/znP6o
         MgAZbVVj4Mwa8Ow09cb0pdGGjLsnDM+ocnnIJflUDCIYMn1VOYnyufws7Kb1TUZOiTXc
         GNFPz9llitZTsOzknCIdN7dDgnolEgxkzmeAFG27ODjcQNGN7dToyn3HxF7YwjxAxJF3
         P36aXaimEtrROrq9g25pP6C1WKNY4DO4ZylJhZBlbktANZuYm02Gtb+kvNGVi1wQScbL
         4Xb7KSUMcxWFKnsAOA52AJaU5TRG9uw004QOzKhELv3t89e6EZ9YmD8hGC8Z3mt7IxWq
         ebjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=cP4NBM0ETOYFq+TZhV3HDz5qwb6s5UdYnKys12wd3oA=;
        b=BZry8zCm/zLGXQxZ0nFp94IGe/z2B55Zl3/9DwHvjc/TeZWwuuk1QBHTSz7l9aWaL1
         mLa7Eb4O0wCAj30tXti+2kAyMVwJWgmVQAPGWiYsv1XT1DtL11vPlCy8j0yfP0B/7stS
         rC6G62kTlDDBHTblPhYiDxB+Rh9jnDlEu1eWnAkC2PuA0BpkGQXA+Gia8qtuqod8SgUf
         TDA8bpTFVloHwl1+OvVyheDGlAoSCm8jAm0pAks9tGfoqPb2aLHBzZmmehlMKvxWyMEu
         MSaHTXMftfI8bIxtMyHnWLtMYsWHHyY1WF9os3EUcOhPAk/6HTLyuwIPaZMt9NQpTQzQ
         s3sg==
X-Gm-Message-State: ACgBeo0+5aQ6Lr+dIkWnzQwYIME+35TBxTOH3I8kksezaxIzBVicvCfj
        OFq1QufOirzDeBNRDTrDtjc=
X-Google-Smtp-Source: AA6agR7KVmiwEFmemAs4F1hF1UrTXwV0rvfCzZrf7a3NLms/q0ccr8sFSxqLchJaYLSit4bKyKkijw==
X-Received: by 2002:a05:6402:641:b0:446:d:bd64 with SMTP id u1-20020a056402064100b00446000dbd64mr28329434edx.32.1662029909487;
        Thu, 01 Sep 2022 03:58:29 -0700 (PDT)
Received: from localhost.localdomain (109-178-192-105.pat.ren.cosmote.net. [109.178.192.105])
        by smtp.gmail.com with ESMTPSA id s25-20020aa7d799000000b0044604ad8b41sm1140919edq.23.2022.09.01.03.58.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 03:58:28 -0700 (PDT)
From:   Michael Bestas <mkbestas@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     hsinyi@chromium.org, mkbestas@gmail.com, rppt@linux.ibm.com,
        stable@vger.kernel.org, swboyd@chromium.org, will@kernel.org
Subject: Re: [PATCH] arm64: map FDT as RW for early_init_dt_scan()
Date:   Thu,  1 Sep 2022 13:57:27 +0300
Message-Id: <20220901105727.606047-1-mkbestas@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <YxCCI2c6l8OdA4GV@kroah.com>
References: <YxCCI2c6l8OdA4GV@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 1 Sep 2022 11:57:55 +0200
Greg KH <gregkh@linuxfoundation.org> wrote:

> Both now queued up, thanks.
>
> greg k-h

Could you also queue the 4.9 patch or I need to send it again?
https://lore.kernel.org/all/20220809145624.1819905-1-mkbestas@gmail.com/

Thanks,

Michael Bestas
