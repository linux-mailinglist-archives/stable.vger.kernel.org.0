Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50FA14E8D04
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 06:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237931AbiC1ESe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 00:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237979AbiC1ESd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 00:18:33 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B0D49F2E;
        Sun, 27 Mar 2022 21:16:53 -0700 (PDT)
Received: from [192.168.12.80] (unknown [182.2.37.32])
        by gnuweeb.org (Postfix) with ESMTPSA id D3D237E70A;
        Mon, 28 Mar 2022 04:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1648441013;
        bh=ekCfYZFyO8eGmn/73LhVUn1u4fP1kyUmzJgS+TFdONY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ARBJrK9/Zov7nfXjk5IwQxp8cExlcXZxgIFYI4fRmkXJn3bks45u2Q3iVfRAm4Gz/
         BwiOxMbbDFOQkbFfTzPB9RMVA2IIH3B4RrdX0uNmUqwEf/k7FCkEzrRcZ0JmG7uUxL
         KMIMtwINctLXiJZOv53sn3g5m4/514hZ1ZkE3AAJvdabHfmR5mQfpfM2nqJjSejsk/
         zTP2KEmjW05HNM2rtZFuE6dCPzX0kAno/v/qw1qx5QP2BwloxyHKFpYPb4u2nGJB3x
         GBBNJtMDC2N6AjmJx5D6oWxGfMx/u9PNKtpjGIM3s72MnlZKjFg/+CE2A2OVhVebVS
         lzrVUhFX/Dvkg==
Message-ID: <55508416-5810-e4ff-8b97-ebec9f8dc8cf@gnuweeb.org>
Date:   Mon, 28 Mar 2022 11:16:42 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v5 1/2] x86/delay: Fix the wrong asm constraint in
 `delay_loop()`
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, gwml@vger.gnuweeb.org, x86@kernel.org,
        David Laight <David.Laight@aculab.com>,
        Jiri Hladky <hladky.jiri@googlemail.com>
References: <20220310015306.445359-1-ammarfaizi2@gnuweeb.org>
 <20220310015306.445359-2-ammarfaizi2@gnuweeb.org> <YkDZY8n1k5SJw9st@zn.tnic>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <YkDZY8n1k5SJw9st@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/28/22 4:38 AM, Borislav Petkov wrote:
> All those Ccs in the commit message are not really needed -
> get_maintainers.pl gives the correct list already.
> 
>> Cc: stable@vger.kernel.org # v2.6.27+
> 
> I don't see the need for the stable Cc. Or do you have a case where
> a corruption really does happen?
> 
>> Fixes: e01b70ef3eb ("x86: fix bug in arch/i386/lib/delay.c file, delay_loop function")
> 
> Commit sha1 (e01b70ef3eb) needs to be at least 12 chars long:
> 
> e01b70ef3eb3 ("x86: fix bug in arch/i386/lib/delay.c file, delay_loop function")
> 
> This is best fixed by doing:
> 
> [core]
>          abbrev = 12
> 
> in your .git/config

Will fix that in the v6.

-- 
Ammar Faizi
