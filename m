Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05785B2650
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 20:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbiIHS4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 14:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbiIHS4G (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 14:56:06 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E31DD9E85
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 11:55:52 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id dv25so10908725ejb.12
        for <stable@vger.kernel.org>; Thu, 08 Sep 2022 11:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=M4098SyJRltzpG7MyAZxLPDr5I5WzKWKipfDdEc1IBg=;
        b=qY9xVnlLM/l4t54GLlyE8W0HR7sO/sIi2riue9ZM+uirfZflztdQktnoZERgL5s8NZ
         ACsjc99R5X55LMf1d5LFheKe08uI/qFk60W91n5LfieX2WiyrsbaBZcItJGMur3lb48J
         MWzsWGZT1LDgq/jjygMFbCSAaAyvvoHGIoSnNV4m6wwGq6fVLsDEGTdD+indpPpH0GQT
         hoxGr8x72WkxjB0S4ZCJe5gUfwXcDS61ipTF004Nu+4xmM/a+YbBoxabQ4hVmo2VbjLW
         der2wWyhiVkFz0wonM+hfr8SYueQPl2Em/A5dOVxak43IntCNBpowrKv1tMCGMbscbY6
         UzGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=M4098SyJRltzpG7MyAZxLPDr5I5WzKWKipfDdEc1IBg=;
        b=xOZFugYbvAWOmQqw746SmDIPq24sx9ZOJbeK62qlEFMs+d9QvumajL11W8Kpbqnbvu
         NFg4bcjgzyzdN1ILCtg2F5/156t9pRuJywrJ+hRfarKybv8YppXcMs3Km85gOtuekfND
         EUeD8pRveKA9u1/AzRzCyIM9cmrD2CNz2yTKS3HHS52+mionpXgvgAfJHL+H87gK5aIu
         SRwKbUanx9VhmZ4DiRsMib3eiUDSj1mMTEd4Vgr882hy14dUMz0QlEjDmuS0shD3WZAj
         WmLAYY7tp8vXIJ6tMhwoqPLJWMlqJVv8SjDJqlNWpS+CYbdYYlzNpdINoPUhEbrlMpuh
         I6Sg==
X-Gm-Message-State: ACgBeo3ysQefQgtTtrwPjUpAE+fya9pTVbUofFkPDzfQ8xddaXXTr/Aa
        TNpO7g0HKeGE2NFZGJoL56tqKN7BD8I9gWPhcUbqcA==
X-Google-Smtp-Source: AA6agR6k5/pgiNgK4VKq2XiLPLalc0PBHjQ/Co4GgNh/K5+cVUaPM73Le7bYBJcBnyp3LtykYdayarpSKiUIwSksaVU=
X-Received: by 2002:a17:907:b04:b0:758:2d05:7aaf with SMTP id
 h4-20020a1709070b0400b007582d057aafmr7119692ejl.33.1662663350763; Thu, 08 Sep
 2022 11:55:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220906172933.410698-1-isaacmanjarres@google.com> <YxnX9TsxuSi9L9GD@kroah.com>
In-Reply-To: <YxnX9TsxuSi9L9GD@kroah.com>
From:   Isaac Manjarres <isaacmanjarres@google.com>
Date:   Thu, 8 Sep 2022 11:55:39 -0700
Message-ID: <CABfwK102o1ycjHnGtR_bt3SZpuHtT=ynLJuWQwBUDqR2Ysg-eg@mail.gmail.com>
Subject: Re: [PATCH stable-4.19/4.14/4.9] driver core: Don't probe devices
 after bus_type.match() probe deferral
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, stable@vger.kernel.org,
        Saravana Kannan <saravanak@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        kernel-team@android.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Applied to 4.19.y, but did not apply to 4.14.y or 4.9.y :(

Thanks for following up on this. I'll make backports for 4.9 and 4.14
separately.

--Isaac
