Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D25E57F37D
	for <lists+stable@lfdr.de>; Sun, 24 Jul 2022 08:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbiGXGuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jul 2022 02:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiGXGuz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jul 2022 02:50:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E14FD13;
        Sat, 23 Jul 2022 23:50:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9392160ECC;
        Sun, 24 Jul 2022 06:50:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBC6C3411E;
        Sun, 24 Jul 2022 06:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658645452;
        bh=0oH/IV9wwJUFggYjwrDW4GxkAkDjKLJ27FwZpyJ+mXM=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=OK6vSCmwuW7PovDpvp1QjiXr1nEEU9iZ4aDBfc4ggYah1ksmm1kx4eKurwui2/qsd
         B4HbMnPCOJHDPCApO5HJTYIYdeKzNxTU6tYaMClTLL90R0pfVohPL+Kt1j3P3GDK4j
         Hnw5COFPX0wCWSO0qt0jw/23cVvuZdIPsfOVe8h5lH3/WC48OGDBRuNWVG00AlL/yd
         ZJcalHsKTBvaNJAcaiyTmxzY3HDy4xbltFXvfAKgZ+F1gxidVajLUrX6SDu78YUxMJ
         Zt4bNRYGGD6e+o8NamRhRNwPTpwzqM7i5hBzEsJ3QMdxvqQ89S7MMejASh3a1AGCzC
         LTHScYI/hZE9w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220627235512.2272783-1-quic_collinsd@quicinc.com>
References: <20220627235512.2272783-1-quic_collinsd@quicinc.com>
Subject: Re: [PATCH] spmi: trace: fix stack-out-of-bound access in SPMI tracing functions
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     David Collins <quic_collinsd@quicinc.com>,
        linux-arm-msm@vger.kernel.org,
        Ankit Gupta <ankgupta@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>, stable@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Sat, 23 Jul 2022 23:50:50 -0700
User-Agent: alot/0.10
Message-Id: <20220724065052.DDBC6C3411E@smtp.kernel.org>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting David Collins (2022-06-27 16:55:12)
> trace_spmi_write_begin() and trace_spmi_read_end() both call
> memcpy() with a length of "len + 1".  This leads to one extra
> byte being read beyond the end of the specified buffer.  Fix
> this out-of-bound memory access by using a length of "len"
> instead.
>=20
> Here is a KASAN log showing the issue:
>=20
> BUG: KASAN: stack-out-of-bounds in trace_event_raw_event_spmi_read_end+0x=
1d0/0x234
> Read of size 2 at addr ffffffc0265b7540 by task thermal@2.0-ser/1314
> ...
> Call trace:
>  dump_backtrace+0x0/0x3e8
>  show_stack+0x2c/0x3c
>  dump_stack_lvl+0xdc/0x11c
>  print_address_description+0x74/0x384
>  kasan_report+0x188/0x268
>  kasan_check_range+0x270/0x2b0
>  memcpy+0x90/0xe8
>  trace_event_raw_event_spmi_read_end+0x1d0/0x234
>  spmi_read_cmd+0x294/0x3ac
>  spmi_ext_register_readl+0x84/0x9c
>  regmap_spmi_ext_read+0x144/0x1b0 [regmap_spmi]
>  _regmap_raw_read+0x40c/0x754
>  regmap_raw_read+0x3a0/0x514
>  regmap_bulk_read+0x418/0x494
>  adc5_gen3_poll_wait_hs+0xe8/0x1e0 [qcom_spmi_adc5_gen3]
>  ...
>  __arm64_sys_read+0x4c/0x60
>  invoke_syscall+0x80/0x218
>  el0_svc_common+0xec/0x1c8
>  ...
>=20
> addr ffffffc0265b7540 is located in stack of task thermal@2.0-ser/1314 at=
 offset 32 in frame:
>  adc5_gen3_poll_wait_hs+0x0/0x1e0 [qcom_spmi_adc5_gen3]
>=20
> this frame has 1 object:
>  [32, 33) 'status'
>=20
> Memory state around the buggy address:
>  ffffffc0265b7400: 00 00 00 00 00 00 00 00 00 00 00 00 f1 f1 f1 f1
>  ffffffc0265b7480: 04 f3 f3 f3 00 00 00 00 00 00 00 00 00 00 00 00
> >ffffffc0265b7500: 00 00 00 00 f1 f1 f1 f1 01 f3 f3 f3 00 00 00 00
>                                            ^
>  ffffffc0265b7580: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffffffc0265b7600: f1 f1 f1 f1 01 f2 07 f2 f2 f2 01 f3 00 00 00 00
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Fixes: a9fce374815d ("spmi: add command tracepoints for SPMI")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Collins <quic_collinsd@quicinc.com>
> ---

Reviewed-by: Stephen Boyd <sboyd@kernel.org>

Greg, can you pick this up directly? I don't have anything else for this
cycle.
