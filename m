Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66F295076C3
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 19:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352395AbiDSRtw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 13:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353399AbiDSRtv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 13:49:51 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92011115A
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 10:47:06 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id z16so9036002pfh.3
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 10:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eJhX1LbAxPHHT8a5Ih0hSyTAg97jWBttV19glVJ+v8g=;
        b=NGwlXY/d9L/tFLU0ev9y4i50/by0rKyFxHo2PLdJ5MuW3pFk72iH/X3g29R/K28UJC
         dMSxWVnBJOqwSwC94yvOv/BO47OIlemSkgGdkZpucwSU2D214XYwUzXRF5Ir4yYWbLNd
         g1AJltZrz1LawumnQf3biNiopIPoSRelFUXeQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eJhX1LbAxPHHT8a5Ih0hSyTAg97jWBttV19glVJ+v8g=;
        b=gxbzxjyOCyOiy5hJ5qjUq/esUveImHMvF7F+J/7dpEaAvrg6BkIxcFoTSNS2G2u+J6
         CdBh7kF6sWYSxlIoSqqKn16XVo/R0XaJNuVa1Zt9obIRy4HBTwUn6iIuXcWAf8SFRlpE
         TlUs1j0qER/RlT3T2JzUBsETpY0jJ3Br2bcQO/+DzlF4apvAe3WbZ5kkqh70X5Sf935w
         d1dq/3VhOQskaGS9U9rs0dOyd8wPfm4oX6HphpV0QZbFwnRL+dt4sJQECx3/Kz3DBZEo
         Es152hCWj3c119OOWSzpylc9GUinT81nJV2+V51cmxz9brYNBISmID75ccNCtc0FjlIP
         YD/g==
X-Gm-Message-State: AOAM53128GIuiohpC8LwN+Mn034q2z4IpOOKpLk3vZDaPp/BsD9pSg2Z
        cHKcASgbXzN0kWmDZLUjqkqhGg==
X-Google-Smtp-Source: ABdhPJzScsflZaDve27ipH6bvurP6DoUeG3G2+wqfWTiSnihmsKylQwmyOc5Dlo9JrZ5ArCsH1H9zg==
X-Received: by 2002:a05:6a00:1254:b0:50a:55c5:5ff7 with SMTP id u20-20020a056a00125400b0050a55c55ff7mr16928195pfi.85.1650390426329;
        Tue, 19 Apr 2022 10:47:06 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id i5-20020a17090a2a0500b001cba3ac9366sm20143182pjd.10.2022.04.19.10.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 10:47:05 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     ebiederm@xmission.com
Cc:     Kees Cook <keescook@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        damien.lemoal@opensource.wdc.com, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Niklas.Cassel@wdc.com,
        lkp@intel.com, vapier@gentoo.org, gerg@linux-m68k.org,
        stable@vger.kernel.org
Subject: Re: (subset) [PATCH] binfmt_flat; Drop vestigates of coredump support
Date:   Tue, 19 Apr 2022 10:46:40 -0700
Message-Id: <165039039729.809958.17874221541968744613.b4-ty@chromium.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <87mtgh17li.fsf_-_@email.froward.int.ebiederm.org>
References: <20220418200834.1501454-1-Niklas.Cassel@wdc.com> <202204181501.D55C8D2A@keescook> <87mtgh17li.fsf_-_@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 19 Apr 2022 09:16:41 -0500, Eric W. Biederman wrote:
> There is the briefest start of coredump support in binfmt_flat.  It is
> actually a pain to maintain as binfmt_flat is not built on most
> architectures so it is easy to overlook.
> 
> Since the support does not do anything remove it.
> 
> 
> [...]

Applied to for-next/execve, thanks! (With typo nits fixed.)

[1/1] binfmt_flat; Drop vestigates of coredump support
      https://git.kernel.org/kees/c/6e1a873cefd1

-- 
Kees Cook

