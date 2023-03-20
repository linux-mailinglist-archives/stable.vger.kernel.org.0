Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20BB6C1A74
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbjCTP5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbjCTP4u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:56:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214D63B22C;
        Mon, 20 Mar 2023 08:48:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 710B0B80EF1;
        Mon, 20 Mar 2023 15:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70169C433EF;
        Mon, 20 Mar 2023 15:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679327297;
        bh=1TrKqHRyeBU3xjpltOpYjc4IeQSvekhiR9ZsQedUAbc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MfRvFuAzcZrbrYHRPj30YCnzqnzPn27iZieM04eMoQug9QIK8ZwITdVopGXCVH/ST
         BAQZs/87rQRILSBljDu1gz+wlpOR2LSkjnm2J4YcHkAwShkeJnDZK4khNvwjOL2sio
         HKni367AieLLX4YGPNcOdCuThjWDaBXksVP28E1g=
Date:   Mon, 20 Mar 2023 16:48:14 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lorenz Bauer <lmb@isovalent.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Martin KaFai Lau <martin.lau@kernel.org>,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        shuah@kernel.org, yhs@fb.com, eddyz87@gmail.com, sdf@google.com,
        error27@gmail.com, iii@linux.ibm.com, memxor@gmail.com,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.2 08/30] selftests/bpf: check that modifier
 resolves after pointer
Message-ID: <ZBiAPngOtzSwDhFz@kroah.com>
References: <20230320005258.1428043-1-sashal@kernel.org>
 <20230320005258.1428043-8-sashal@kernel.org>
 <CAN+4W8g6AcQQWe7rrBVOFYoqeQA-1VbUP_W7DPS3q0k-czOLfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAN+4W8g6AcQQWe7rrBVOFYoqeQA-1VbUP_W7DPS3q0k-czOLfg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 20, 2023 at 03:31:42PM +0000, Lorenz Bauer wrote:
> On Mon, Mar 20, 2023 at 12:53 AM Sasha Levin <sashal@kernel.org> wrote:
> >
> > From: Lorenz Bauer <lorenz.bauer@isovalent.com>
> >
> > [ Upstream commit dfdd608c3b365f0fd49d7e13911ebcde06b9865b ]
> >
> > Add a regression test that ensures that a VAR pointing at a
> > modifier which follows a PTR (or STRUCT or ARRAY) is resolved
> > correctly by the datasec validator.
> >
> > Signed-off-by: Lorenz Bauer <lmb@isovalent.com>
> > Link: https://lore.kernel.org/r/20230306112138.155352-3-lmb@isovalent.com
> > Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Hi Sasha,
> 
> Can you explain why this patch was selected? I'd prefer to not
> backport the test, since it frequently leads to breakage when trying
> to build selftests/bpf on stable kernels.

Why would it break?  Is that because the test is buggy, or the kernel is
buggy?

thanks,

greg k-h
