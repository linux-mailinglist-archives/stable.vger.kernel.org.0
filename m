Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A87227E8F
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 15:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730668AbfEWNqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 09:46:30 -0400
Received: from www62.your-server.de ([213.133.104.62]:51730 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729902AbfEWNqa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 09:46:30 -0400
Received: from [88.198.220.132] (helo=sslproxy03.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hTo3A-0003BO-4A; Thu, 23 May 2019 15:46:28 +0200
Received: from [178.197.249.12] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hTo39-0008Tu-N1; Thu, 23 May 2019 15:46:27 +0200
Subject: Re: [PATCH 4.19 144/187] selftests/bpf: skip verifier tests for
 unsupported program types
To:     "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     "sashal@kernel.org" <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "sdf@google.com" <sdf@google.com>
References: <20190404084603.119654039@linuxfoundation.org>
 <20190404084609.946908305@linuxfoundation.org>
 <16ec5436310b0df657a4898e3d15ccc3b9aab8e2.camel@nokia.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <47a9ede3-bef8-7ae1-6353-b954b6e7f7af@iogearbox.net>
Date:   Thu, 23 May 2019 15:46:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <16ec5436310b0df657a4898e3d15ccc3b9aab8e2.camel@nokia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25458/Thu May 23 09:58:32 2019)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/23/2019 12:27 PM, Rantala, Tommi T. (Nokia - FI/Espoo) wrote:
> On Thu, 2019-04-04 at 10:48 +0200, Greg Kroah-Hartman wrote:
>> 4.19-stable review patch.  If anyone has any objections, please let
>> me know.
>>
>> ------------------
>>
>> [ Upstream commit 8184d44c9a577a2f1842ed6cc844bfd4a9981d8e ]
>>
>> Use recently introduced bpf_probe_prog_type() to skip tests in the
>> test_verifier() if bpf_verify_program() fails. The skipped test is
>> indicated in the output.
> 
> Hi, this patch added in 4.19.34 causes test_verifier build failure, as
> bpf_probe_prog_type() is not available:
> 
> gcc -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf
> -I../../../../include/generated -DHAVE_GENHDR
> -I../../../include    test_verifier.c /root/linux-
> 4.19.44/tools/testing/selftests/bpf/libbpf.a -lcap -lelf -lrt -lpthread
> -o /root/linux-4.19.44/tools/testing/selftests/bpf/test_verifier
> test_verifier.c: In function ‘do_test_single’:
> test_verifier.c:12775:22: warning: implicit declaration of function
> ‘bpf_probe_prog_type’; did you mean ‘bpf_program__set_type’? [-
> Wimplicit-function-declaration]
>   if (fd_prog < 0 && !bpf_probe_prog_type(prog_type, 0)) {
>                       ^~~~~~~~~~~~~~~~~~~
>                       bpf_program__set_type
> /usr/bin/ld: /tmp/ccEtyLhk.o: in function `do_test_single':
> test_verifier.c:(.text+0xa19): undefined reference to
> `bpf_probe_prog_type'
> collect2: error: ld returned 1 exit status
> make[1]: *** [../lib.mk:152: /root/linux-
> 4.19.44/tools/testing/selftests/bpf/test_verifier] Error 1

Looks like this kselftest one got auto-selected for stable? It's not
strictly needed, so totally fine to drop.

Thanks,
Daniel
