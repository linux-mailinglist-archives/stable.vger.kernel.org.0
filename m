Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA9E66AAB2
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 10:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbjANJtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 04:49:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjANJtl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 04:49:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206A34495;
        Sat, 14 Jan 2023 01:49:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4D853CE094D;
        Sat, 14 Jan 2023 09:49:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A94C433D2;
        Sat, 14 Jan 2023 09:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673689777;
        bh=TT7LW8NCfKZAZ5tbf26aWuoR1X/W1r0kjlbWoecMFvQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ixzhz22seGNw/OP0JpgNyx/ah7L3JyrV6HZxGOsyv9U53FnmT+2AyfotkEyBXd/9T
         C1QV5Xg58Azz/jTLhy7qNhErPV+/FLBI1TYB3ImiRwCaUp1zUZpWUYNfbM6pC6+dWa
         jycK19ZGi2ZeybUJ4firnEn0q/mVtZu/a6N8+iK8=
Date:   Sat, 14 Jan 2023 10:49:34 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     stable@vger.kernel.org, pbonzini@redhat.com, shuah@kernel.org,
        kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Darren Kenny <darren.kenny@oracle.com>,
        Liam Merwick <liam.merwick@oracle.com>
Subject: Re: 5.15.y backport request to fix compilation error in selftests/kvm
Message-ID: <Y8J6rmzmwoZq4g19@kroah.com>
References: <2322a626-ac5a-9400-82bf-3aaccc5fddb7@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2322a626-ac5a-9400-82bf-3aaccc5fddb7@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 13, 2023 at 03:32:25PM +0530, Harshit Mogalapalli wrote:
> Hi,
> 
> On arm machine we have a compilation error while building
> tools/testing/selftests/kvm/ with LTS 5.15.y kernel
> 
> rseq_test.c: In function ‘main’:
> rseq_test.c:236:33: warning: implicit declaration of function ‘gettid’; did
> you mean ‘getgid’? [-Wimplicit-function-declaration]
>           (void *)(unsigned long)gettid());
>                                  ^~~~~~
>                                  getgid
> /tmp/cc4Wfmv2.o: In function `main':
> /home/test/linux/tools/testing/selftests/kvm/rseq_test.c:236: undefined
> reference to `gettid'
> collect2: error: ld returned 1 exit status
> make: *** [../lib.mk:151:
> /home/test/linux/tools/testing/selftests/kvm/rseq_test] Error 1
> make: Leaving directory '/home/test/linux/tools/testing/selftests/kvm'
> 
> 
> This is fixed by commit 561cafebb2cf97b0927b4fb0eba22de6200f682e upstream.
> Kernel version to apply: 5.15.y LTS
> 
> Could we please backport the above fix onto 5.15.y LTS. It applies cleanly
> and the kvm selftests compile properly after applying the patch.

Now queued up, thanks.

greg k-h
