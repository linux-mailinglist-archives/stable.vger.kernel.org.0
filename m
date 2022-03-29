Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 559E84EA49B
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 03:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiC2Bak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 21:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiC2Baj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 21:30:39 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7C817A99;
        Mon, 28 Mar 2022 18:28:58 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id c11so13525424pgu.11;
        Mon, 28 Mar 2022 18:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8RWKOtmx36LC8yLEISKBczl/3PqgfL2wdJ+l1FkdZvo=;
        b=gmqfmXDEr/Jg/JcEXwQ/nAYvX4nu4pGb0MkhP8/V3+vHw2sDt3mmAouBJdogl3FHoN
         KINdxmZcZpu8iHiRrmgD7JkCVFSslmY1fD8C/gOFuvg6aR2YbomWdBaxjeXiAfG9cJaq
         2l5oL4+NHXleL7U3dNvCGRD+DEtiSq9M4FU463V6E8hxGwb6TSPUYIsxvDFe8EMpozOu
         FCBgyTLLIx7Rqf9ikuDLNAHXSbby7NTrM7OVXleuoNh0/4RwcmGBvETds2XNxSxkQeuv
         YlCCOexSVhM4KK0BQt+45333YxKPCzDi7uhR3YxypzjD/QUbt+o8jf26Xiq0vOKnPwa1
         752w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8RWKOtmx36LC8yLEISKBczl/3PqgfL2wdJ+l1FkdZvo=;
        b=l6wfXvVzB0bl/ASvTwavirPT04eFdVT3Jn+g/QhF0dFNzPyysC1HZfFEYVIioqYAcQ
         oL4Q2IeEDYCDff3ljZjfE2/eZXeEOprkGE/xFF0zGdp76tNGEFAlZrFz3n7u7EKpeCie
         Cd1FV7VCKDSA5Qb4GtYNbj/+j5APr3nR8I44LkZvutd26yutAeDUu4EKH8mCuRtnjyRy
         02ZqoS1vC060Qp615QsNGiJh4bbbQBkSpUXChj3XNBwRrIpqSNGQEWWuCMBvXAP/NDJD
         KKFaCP5KVh1jG4+2o9+o4/+w645eF4bpToOHFPERFQxEH+T4by/Ye5Gp6cRgS7QgaVMs
         cAHQ==
X-Gm-Message-State: AOAM533R/8Qjr3yLsq48yBso9JaTDslAXolVK9e1gjtBxxQO0XTU0vBF
        cqgNydNkbhgwQmlMWIZsG0A=
X-Google-Smtp-Source: ABdhPJx3pXQp5CBClxzCKjbibsuK3ueJtHhSUlztbLQ0G6UdL+LbDrcIrkqV57I1BEtcrXg2kbUWbQ==
X-Received: by 2002:a05:6a00:14c6:b0:4fa:eae3:ffe4 with SMTP id w6-20020a056a0014c600b004faeae3ffe4mr24910871pfu.45.1648517337688;
        Mon, 28 Mar 2022 18:28:57 -0700 (PDT)
Received: from localhost ([119.3.119.18])
        by smtp.gmail.com with ESMTPSA id s10-20020a63a30a000000b003987eaef296sm348236pge.44.2022.03.28.18.28.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 28 Mar 2022 18:28:57 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     broonie@kernel.org
Cc:     alsa-devel@alsa-project.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, perex@perex.cz,
        stable@vger.kernel.org, tiwai@suse.com, xiam0nd.tong@gmail.com
Subject: Re: [PATCH] soc: soc-dapm: fix two incorrect uses of list iterator
Date:   Tue, 29 Mar 2022 09:28:48 +0800
Message-Id: <20220329012848.9564-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <YkHi98GDDWNie7GP@sirena.org.uk>
References: <YkHi98GDDWNie7GP@sirena.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Mar 2022 17:31:51 +0100, Mark Brown wrote:
> On Sun, Mar 27, 2022 at 04:21:38PM +0800, Xiaomeng Tong wrote:
> 
> >  		case snd_soc_dapm_pre:
> > -			if (!w->event)
> > +			if (!w->event) {
> >  				list_for_each_entry_safe_continue(w, n, list,
> >  								  power_list);
> > +				break;
> > +			}
> 
> This doesn't make much sense.  The intent here seems to clearly be to
> continue; the loop but this doesn't do that - instead it appears that
> continue doesn't actually do the equivalent of a continue but rather
> skips over an entry.  This should instead be replaced with a plain
> continue statement.
> 

Yes, you are right. Sorry for a slip of the pen in commit message:
should be "to *continue* the outer list_for_each_entry_safe() loop"
not "to break ...".

I have resend a PATCH v2 for the fix as you suggested, and cc you.
Thank you.

> THe naming of _continue() needs fixing I think - it's just asking to be
> a bug.  Fortunately there's very few users.

--
Xiaomeng Tong
