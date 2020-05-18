Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C5D1D802B
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgERRbF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:31:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbgERRbE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:31:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0A8220715;
        Mon, 18 May 2020 17:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823064;
        bh=/bu7EaDOQo5IxcHnOuVKXMa41oiV41ueUkTCNQgJrn8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WO8zWNLRuhyLhDIc96XGZyLDKPYF/ZERmTDFbET0X45pkWlpEn9Z650sbWywIDnlj
         bwYDU2u9fssIgAv8dCswc00fJ6MMd54QC+stBMoZYWwd4lYtfqvkqa9kf1u46LsyAr
         1uxEVdvCuRZZK6H/1RnItRCdkC9QUDWJIiaahidk=
Date:   Mon, 18 May 2020 19:31:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Subject: Re: stable-rc 4.19: =?utf-8?Q?lib=2Fvsprin?=
 =?utf-8?Q?tf=2Ec=3A1983=3A11=3A_error=3A_implicit_declaration_of_function?=
 =?utf-8?B?IOKAmGVycm9yX3N0cmluZ+KAmSBbLVdlcnJvcj1pbXBsaWNpdC1mdW5jdGlv?=
 =?utf-8?Q?n-declaration?= =?utf-8?Q?=5D?=  1983 | return error_string(buf,
 end, "(einval)", spec);
Message-ID: <20200518173101.GA2394423@kroah.com>
References: <CA+G9fYtUOp8d1ktnp_-34AczAqR+eCj7UfD9u30hdYAey66syw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYtUOp8d1ktnp_-34AczAqR+eCj7UfD9u30hdYAey66syw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 18, 2020 at 10:49:08PM +0530, Naresh Kamboju wrote:
> stable-rc 4.19 build broken on arm64, arm, x86_64 and i386.
> 
>  # make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=x86
> HOSTCC=gcc CC="sccache gcc" O=build
> 75 #
> 76 kernel/locking/rwsem.o: warning: objtool: up_read()+0x11: call
> without frame pointer save/setup
> 77 kernel/locking/rwsem.o: warning: objtool: up_write()+0x17: call
> without frame pointer save/setup
> 78 kernel/locking/rwsem.o: warning: objtool: downgrade_write()+0x25:
> call without frame pointer save/setup
> 79 ../drivers/crypto/ccp/sp-platform.c:37:34: warning: array
> ‘sp_of_match’ assumed to have one element
> 80  37 | static const struct of_device_id sp_of_match[];
> 81  | ^~~~~~~~~~~
> 82 ../lib/vsprintf.c: In function ‘pointer’:
> 83 ../lib/vsprintf.c:1983:11: error: implicit declaration of function
> ‘error_string’ [-Werror=implicit-function-declaration]
> 84  1983 | return error_string(buf, end, "(einval)", spec);
> 85  | ^~~~~~~~~~~~
> 86 ../lib/vsprintf.c:1983:11: warning: returning ‘int’ from a function
> with return type ‘char *’ makes pointer from integer without a cast
> [-Wint-conversion]
> 87  1983 | return error_string(buf, end, "(einval)", spec);
> 88  | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 89 cc1: some warnings being treated as errors
> 
> ref:
> https://gitlab.com/Linaro/lkft/kernel-runs/-/jobs/557410092
> https://gitlab.com/Linaro/lkft/kernel-runs/-/jobs/557410099

Should all now be fixed, sorry for the churn.

greg k-h
