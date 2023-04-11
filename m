Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C84386DDF5D
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 17:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbjDKPQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 11:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbjDKPQj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 11:16:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696A5619B;
        Tue, 11 Apr 2023 08:15:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A39236285C;
        Tue, 11 Apr 2023 15:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7E3C433D2;
        Tue, 11 Apr 2023 15:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681226080;
        bh=3YqIy9422W4j5TAiKhuwgA4sZIXX6+PQPhFS0rtef+I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cyirtFO/mCjXYL12aZzM/ARuJs3BAEh/6mAwWNpSNDiHwLJXFmMxnndVk0mdQJ94H
         QbvIzQk6nPI866muT6LeB+lXXsPmNyqGIl+G/0x+s/OqrPMmyuZJ54cLd5gRwv7kTN
         65zNRwUVN7eV+pjUA+OT/8qqLwlgWV3kOwHy1hZM=
Date:   Tue, 11 Apr 2023 17:14:37 +0200
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
Message-ID: <2023041100-oblong-enamel-5893@gregkh>
References: <20230320005258.1428043-1-sashal@kernel.org>
 <20230320005258.1428043-8-sashal@kernel.org>
 <CAN+4W8g6AcQQWe7rrBVOFYoqeQA-1VbUP_W7DPS3q0k-czOLfg@mail.gmail.com>
 <ZBiAPngOtzSwDhFz@kroah.com>
 <CAN+4W8jAyJTdFL=tgp3wCpYAjGOs5ggo6vyOg8PbaW+tJP8TKA@mail.gmail.com>
 <CAN+4W8j5qe6p3YV90g-E0VhV7AmYyAvt0z50dfDSombbGghkww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAN+4W8j5qe6p3YV90g-E0VhV7AmYyAvt0z50dfDSombbGghkww@mail.gmail.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 11, 2023 at 04:08:32PM +0100, Lorenz Bauer wrote:
> On Tue, Mar 28, 2023 at 11:18 AM Lorenz Bauer <lmb@isovalent.com> wrote:
> >
> > On Mon, Mar 20, 2023 at 3:48 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > Why would it break?  Is that because the test is buggy, or the kernel is
> > > buggy?
> >
> > This test will be fine, but there have been several times when
> > selftests/bpf for stable kernel releases didn't actually compile due
> > to backported tests. This is because macros we're redefined, etc.
> > Unless those also get picked (seems like a sisyphean task) we'll keep
> > seeing broken selftests/bpf on stable.
> 
> Hi Greg, Sasha,
> 
> Following up on this since it seems to have fallen through the cracks.

I didn't see anything to do here.

And selftests should NOT be broken on stable releases, if so, something
is wrong as no other subsystem has that happen.

confused,

greg k-h
