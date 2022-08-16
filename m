Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85016595EC1
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 17:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236046AbiHPPIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 11:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235314AbiHPPIP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 11:08:15 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4C4C36
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 08:07:32 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id z20so10833915ljq.3
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 08:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=+IhunWuA6ewS2AlO2uM9pN5fO1zJRhIKo3kCmndoEDA=;
        b=mOfF0jeUhsGqSMyomQjQW1mqU3ytbYlX4ViYcnq0r0QL+tqakAYQ60qFCmbJnIvn4c
         cMp7c9Ub8wr7VBNteWRBMqHSYskdUgOIWnalNaj9dxQ53Fi8YXAEGoNTMiKC/hN9vd1Q
         g1exWdhkjM0sFh1KChyMbzej+3bJz6BkhiqfQi4XXAGymnrFzXP6kSm9na1DcaL5kLFN
         XpMx1rPWt28gYKOOPz3+THQH9pedtRUXYaiPLrzGhBP8Zd0X96JFIlz0uikNiG2DpNDY
         I9TlsftdVsMwyZqKs8vnZ8vNX4eYJhzZREu7mnNZiGSyDZqcAsF3GIiZ3f23BmH8833f
         355A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=+IhunWuA6ewS2AlO2uM9pN5fO1zJRhIKo3kCmndoEDA=;
        b=0NU+cy9Y2B81zukKQzzqkww55q7Vgn7s4HivJIMOJLFWnqCk8CKmUQWzTx75QeLHJB
         bXl8oAOtvgrQqYv+JVTNjctW/9yCUtfr1gzyh4g3EvcU6kDqItZW4MKSZrTbWS6Qd/ch
         Go0x8q0WmDDtFdMvIUEnsAK9WpkB/V+8JVS/91vCOIgDFbtWXVXfUmKaeuckIrUIdFIf
         L9fXLzOO09Oj1JwjhyzOF/qkV5z6DvhGG6jUUBQHTwoIjFKN62+JWtnQEyxJiYXA/pxt
         bAaH6Mhx3j1qwL4kASj1J/Pp3BrgJjCinBP9x8gBKPDlNqc0EvGSK7zLtDG4Wvjq4g3b
         68lQ==
X-Gm-Message-State: ACgBeo1Ffc4Cn4gc9LZZHwdtFfRV8f0IYpSOKFzQz1g0UmBqQ+KxAX8G
        BlaXdN3mwl5izIDQpZPncuPi
X-Google-Smtp-Source: AA6agR52FX6OfBuqZveiKkQUNcbkCsxNQYkcc9jbzwu+MLxDsSH92xsPei9voPoqBoA0yhlbdFf8ww==
X-Received: by 2002:a2e:804e:0:b0:25e:7231:c304 with SMTP id p14-20020a2e804e000000b0025e7231c304mr6506566ljg.257.1660662450529;
        Tue, 16 Aug 2022 08:07:30 -0700 (PDT)
Received: from Mem (2a01cb0890e296006905f2f810da8415.ipv6.abo.wanadoo.fr. [2a01:cb08:90e2:9600:6905:f2f8:10da:8415])
        by smtp.gmail.com with ESMTPSA id m23-20020a2e8717000000b0025e5631194dsm1815999lji.21.2022.08.16.08.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 08:07:30 -0700 (PDT)
Date:   Tue, 16 Aug 2022 17:07:27 +0200
From:   Paul Chaignon <paul@isovalent.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.19 0537/1157] bpf: Set flow flag to allow any source IP
 in bpf_tunnel_key
Message-ID: <20220816150727.GA88824@Mem>
References: <20220815180439.416659447@linuxfoundation.org>
 <20220815180501.149595269@linuxfoundation.org>
 <20220816143554.GA67569@Mem>
 <YvuuAprVhybi0CMj@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvuuAprVhybi0CMj@kroah.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 04:47:30PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Aug 16, 2022 at 04:35:54PM +0200, Paul Chaignon wrote:
> > On Mon, Aug 15, 2022 at 07:58:13PM +0200, Greg Kroah-Hartman wrote:
> > > From: Paul Chaignon <paul@isovalent.com>
> > > 
> > > [ Upstream commit b8fff748521c7178b9a7d32b5a34a81cec8396f3 ]
> > > 
> > > Commit 26101f5ab6bd ("bpf: Add source ip in "struct bpf_tunnel_key"")
> > > added support for getting and setting the outer source IP of encapsulated
> > > packets via the bpf_skb_{get,set}_tunnel_key BPF helper. This change
> > > allows BPF programs to set any IP address as the source, including for
> > > example the IP address of a container running on the same host.
> > > 
> > > In that last case, however, the encapsulated packets are dropped when
> > > looking up the route because the source IP address isn't assigned to any
> > > interface on the host. To avoid this, we need to set the
> > > FLOWI_FLAG_ANYSRC flag.
> > 
> > This fix will also require upstream commits 861396ac0b47 ("geneve: Use
> > ip_tunnel_key flow flags in route lookups") and 7e2fb8bc7ef6 ("vxlan:
> > Use ip_tunnel_key flow flags in route lookups") to have the intended
> > effect. In short, these two commits "consume" the new field introduced
> > in 451ef36bd229 ("ip_tunnels: Add new flow flags field to
> > ip_tunnel_key") and populated in the present commit.
> 
> Ick.  Is it better to just drop this commit instead?  Or is it ok to
> also backport those 2 patches to 5.19.y?

It should be okay to backport those additional 2 patches to 5.19.y.

Thank you,

--
Paul
