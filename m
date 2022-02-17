Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5F84BAA7A
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 20:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245590AbiBQT7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 14:59:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245602AbiBQT7f (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 14:59:35 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFD328E35
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 11:59:20 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id u1so10849512wrg.11
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 11:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5u2bG+DushKHw17yOrbIaQz23Qknrv0LkMPMr61gx3s=;
        b=fwcQDr2dVH1eylGT0jk9xF2NVuEKy08fDSrTh9GoqmbNBBay5785FNtJ2fmQjLodtB
         M17okORGVHRzD8SN0FRcJrxtWOwH2gwbmujIbNzU4NZAW+fDPpSvRILQXZVKIjDXfKQN
         j8tsL2hwye6TJOTzH7VtxvoQgs0WAZAXDjqt5jrZCABdWf8fvTxThJUwRINXOe4aON9s
         hG2Z388hqL1V1n1x19Y1FSFrj1LZvYfcr9K7zh64TzhGh2Ct6wjMyhAViqM68+8R/irP
         7OjlU/bB850vLmbdlePyv1vMCbeVEZLeyhNe5fH5Gnk4jUlnjl5wKW5kBb7mK+NUauKD
         acIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5u2bG+DushKHw17yOrbIaQz23Qknrv0LkMPMr61gx3s=;
        b=48dhRHeUgrAnEZXrgzImxeoDbI9rxRNXAO5RZjQi0QIg0NKMdi6LQt7oD3wcI3BjsE
         /26P+9SXOmdEvNhCab9xmmMpsoIAM/i32vcNWB0qUMgmQsQEt4VXGc6be+RwzcbJXy0U
         PMnVIwyjaqpdoiYhlqSqlw/8r7CCsarVbMzqNZy6/q7HvVkjup8NqrkLXRg+remY0+UV
         TTdK3Avj3kr7/K79jgn7fhIgNCTKmdSB1h6OPSHXoZ5rnToHf1+adn4GjQqe8x4XndQX
         hYfrQy55tL9NV2KF02nJxT7eVyCFaxGk9XIFi6rV8dQioTV5y28vLFd4PhGUjHNjMfCz
         vkkg==
X-Gm-Message-State: AOAM5333LnLphG06HZ7gcQ7sN8wMn4gjQoEOj9p/V6e2d2K1WcTLx+Ij
        kf7o1CloMRUYMAymK1zqQuYiX6FaYlXdan/yf+p5qQ==
X-Google-Smtp-Source: ABdhPJyeuHIE7yho5mVSdJJWYGWyIdp/iE0M6XGAa74OWNmS38I+mQ8oz0AiEr+d5ITv3V4/xyu9zOvfi5lErjOqQLY=
X-Received: by 2002:a5d:5983:0:b0:1e5:7dd6:710 with SMTP id
 n3-20020a5d5983000000b001e57dd60710mr3579753wri.392.1645127959146; Thu, 17
 Feb 2022 11:59:19 -0800 (PST)
MIME-Version: 1.0
References: <20220216225209.2196865-1-haoluo@google.com> <Yg6cixLJFoxDmp+I@kroah.com>
In-Reply-To: <Yg6cixLJFoxDmp+I@kroah.com>
From:   Hao Luo <haoluo@google.com>
Date:   Thu, 17 Feb 2022 11:59:07 -0800
Message-ID: <CA+khW7i2AcUtvAKspnA1wmPT6MaOQ=YwFYmL8ZLmO+o2+ZB-cg@mail.gmail.com>
Subject: Re: [PATCH stable linux-5.16.y 0/9] Fix bpf mem read/write vulnerability.
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, laura@labbott.name,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 17, 2022 at 11:05 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Feb 16, 2022 at 02:52:00PM -0800, Hao Luo wrote:
> > Hi Greg,
> >
> > Please consider cherry-pick this patch series into 5.16.x stable. It
> > includes a fix to a bug in 5.16 stable which allows a user with cap_bpf
> > privileges to get root privileges. The patch that fixes the bug is
> >
> >  patch 7/9: bpf: Make per_cpu_ptr return rdonly
> >
> > The rest are the depedences required by the fix patch. This patchset has
> > been merged in mainline v5.17. The patches were not planned to backport
> > because of its complex dependences.
>
> How about 5.10 or 5.15?  Any chance to backport them there too?
>

If I understand correctly, the attack requires commit:

541c3bad8dc5 bpf: Support BPF ksym variables in kernel modules

which is included in 5.12. The attacker needs to load a self-defined
btf. I'm taking a look at backporting to 5.15.
