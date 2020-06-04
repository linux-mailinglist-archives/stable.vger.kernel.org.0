Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADF51EEA28
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 20:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730371AbgFDSQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jun 2020 14:16:21 -0400
Received: from mout.perfora.net ([74.208.4.196]:41257 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729856AbgFDSQU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Jun 2020 14:16:20 -0400
Received: from [192.168.123.2] ([72.192.149.107]) by mrelay.perfora.net
 (mreueus002 [74.208.5.2]) with ESMTPSA (Nemesis) id 0MDRPv-1jjsXu20sv-00Gqxu;
 Thu, 04 Jun 2020 20:16:11 +0200
Subject: Re: [PATCH nf] nft_set_rbtree: Don't account for expired elements on
 insertion
To:     Phil Sutter <phil@nwl.cc>, Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        stable@vger.kernel.org, netfilter-devel@vger.kernel.org
References: <924e80c7b563cc6522a241b123c955c18983edb1.1591141588.git.sbrivio@redhat.com>
 <20200603153531.GS31506@orbyte.nwl.cc>
From:   Mike Dillinger <miked@softtalker.com>
X-Tagtoolbar-Keys: D20200604111609461
Message-ID: <79640a97-b164-42c4-cc24-2be1c2265e44@softtalker.com>
Date:   Thu, 4 Jun 2020 11:16:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200603153531.GS31506@orbyte.nwl.cc>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Provags-ID: V03:K1:xnOaNxaqT6I9IpQezLahS/A0L5efRZ/p90d8tgQ13oOwm8+RZnU
 iVZdhhCLslBOiUkTbbX60F26QPIsUjtmlZxnaWERVxrBWyJ/FF9beZJqPthoyPkevzKFaT8
 u2BTqfxWKZ+k39icz53BllwwDO5BWp0DBVaknc2V1TepDoTY+oEqIU2ZYuSK8HqtzaXVzvx
 E4hDWhsUjwwoTOoKRbXjQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:fIdiQ4vSmxU=:co/LXnM9yiewfkNg9/g+rf
 v2lpi0pzrc+SNVxbFjg4VQhsQgXmxjZJNqTY6u8Fw/lit8/ai7bBiqz6qhFXyFH6NuRzztRR2
 sGJ9uwGPy2mIxYocEtMoxEXbtAHrPTQleVDhYMXBGfVTWo1vkiGUZpyLDoaRHpNnG91Q0YrUp
 Lf6ZrPampMrx1BrVkfciyimPnoytMRAhXxGJPIseqYD6/W5Qhcl9LmvSL/yHbkw6pwI9qYRjh
 7YKw5ZiuZ2kTLGvYdZB57dR2WuNHu0av+OadJ1AbmfisTRC6yk+3gJUpUHuVN1R7aKOSZCLtR
 bipSIpo8F3HYxJP2RIii9mqZRYAfg44PXdZzqh6IEONhMI5VSDrl1ufAOZtlC4sjwEjDZJU4P
 kODGe9F2IVaseGe0EZEszYh21rr81WNpHJloezXWsM1puqyArdWm8BMuszHJdj8B5Zd6e19xl
 FxKkRkSzCb2ANRD8QNw6+rToe8LBlPEpEx17BbZolylQx2jSmqoSk+96Xqa+pJPxdvgB3oRYl
 y1hVzCX3AxCS6DCF/RtcFiwpQ8Ev8EPOd37HrW7a1UhZGNpU4rwT6RydIISkU0waCyyrq8rri
 7LZiw5ASmMwS0CZB013ZIBlMdydPAhdLIhx6vt9onFhcHZkcfWINfY6Nh+C6aV50Fn1DEl36s
 opvr6kbDXe9UqtzEmU3w5kID+a4odlVK4JaaoNrqZpC5+FR9lt2R5qwEbOgKwNxc+5+MNx6Tt
 7CcBWUNDkOdfWqgd33zY+CXxUFfv3URuZ0TGTbpMRnlxfEtUjzrtBYcuItmT15Taoq9CAF4vZ
 Y4qcyiujaf7oc1el3I3UFY5oCmZwEo43t44aS8i+1Lsf3b+a5wGByoQMtETo7E0I6jOXIKC
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Signed-off-by: Stefano Brivio<sbrivio@redhat.com>
> ---
>   .../testcases/sets/0044interval_overlap_0     | 81 ++++++++++++++-----
>   1 file changed, 61 insertions(+), 20 deletions(-)
>
> diff --git a/tests/shell/testcases/sets/0044interval_overlap_0 b/tests/shell/testcases/sets/0044interval_overlap_0
> index fad92ddcf356..16f661a00116 100755
> --- a/tests/shell/testcases/sets/0044interval_overlap_0
> +++ b/tests/shell/testcases/sets/0044interval_overlap_0
> @@ -7,6 +7,13 @@
>   #   existing one
>   # - for concatenated ranges, the new element is less specific than any existing
>   #   overlapping element, as elements are evaluated in order of insertion
> +#
> +# Then, repeat the test with a set configured for 1s timeout, checking that:
> +# - we can insert all the elements as described above
> +# - once the timeout has expired, we can insert all the elements again, and old
> +#   elements are not present
> +# - before the timeout expires again, we can re-add elements that are not
> +#   expected to fail, but old elements might be present
>   
>   #	Accept	Interval	List
>   intervals_simple="
> @@ -39,28 +46,62 @@ intervals_concat="
>   	y	15-20 . 49-61	0-2 . 0-3, 10-20 . 30-40, 15-20 . 50-60, 3-9 . 4-29, 15-20 . 49-61
>   "
>   
> -$NFT add table t
> -$NFT add set t s '{ type inet_service ; flags interval ; }'
> -$NFT add set t c '{ type inet_service . inet_service ; flags interval ; }'
> +match_elements() {
> +	skip=0
> +	n=0
> +	out=
> +	for a in $($NFT list set t ${1})}; do
> +		[ ${n} -eq 0 ] && [ "${a}" = "elements" ] && n=1
> +		[ ${n} -eq 1 ] && [ "${a}" = "=" ]	  && n=2
> +		[ ${n} -eq 2 ] && [ "${a}" = "{" ]	  && n=3 && continue
> +		[ ${n} -lt 3 ] 					 && continue
> +
> +		[ "${a}" = "}" ]				 && break
> +
> +		[ ${skip} -eq 1 ] && skip=0 && out="${out},"	 && continue
> +		[ "${a}" = "expires" ] && skip=1		 && continue
> +
> +		[ -n "${out}" ] && out="${out} ${a}" || out="${a}"
> +	done
> +	[ "${out%,}" = "${2}" ]
> +}
>   
> -IFS='	
> +add_elements() {
> +	set="s"
> +	IFS='	
>   '
> -set="s"
> -for t in ${intervals_simple} switch ${intervals_concat}; do
> -	[ "${t}" = "switch" ] && set="c"         && continue
> -	[ -z "${pass}" ]      && pass="${t}"     && continue
> -	[ -z "${interval}" ]  && interval="${t}" && continue
> +	for t in ${intervals_simple} switch ${intervals_concat}; do
> +		unset IFS
> +		[ "${t}" = "switch" ] && set="c"         && continue
> +		[ -z "${pass}" ]      && pass="${t}"     && continue
> +		[ -z "${interval}" ]  && interval="${t}" && continue
>   
> -	if [ "${pass}" = "y" ]; then
> -		$NFT add element t ${set} "{ ${interval} }"
> -	else
> -		! $NFT add element t ${set} "{ ${interval} }" 2>/dev/null
> -	fi
> -	$NFT list set t ${set} | tr -d '\n\t' | tr -s ' ' | \
> -		grep -q "elements = { ${t} }"
> +		if [ "${pass}" = "y" ]; then
> +			$NFT add element t ${set} "{ ${interval} }"
> +		else
> +			! $NFT add element t ${set} "{ ${interval} }" 2>/dev/null
> +		fi
>   
> -	pass=
> -	interval=
> -done
> +		[ "${1}" != "nomatch" ] && match_elements "${set}" "${t}"
>   
> -unset IFS
> +		pass=
> +		interval=
> +		IFS='	
> +'
> +	done
> +	unset IFS
> +}
> +
> +$NFT add table t
> +$NFT add set t s '{ type inet_service ; flags interval ; }'
> +$NFT add set t c '{ type inet_service . inet_service ; flags interval ; }'
> +add_elements
> +
> +$NFT flush ruleset
> +$NFT add table t
> +$NFT add set t s '{ type inet_service ; flags interval,timeout; timeout 1s; gc-interval 1s; }'
> +$NFT add set t c '{ type inet_service . inet_service ; flags interval,timeout ; timeout 1s; gc-interval 1s; }'
> +add_elements
> +sleep 1
> +add_elements
> +add_elements nomatch

Hello All,

Is there any way I can track this change so I know what kernel version to expect it in?  Pardon my ignorance, but I'm new to Linux kernel changes.  I have familiarity with change requests, so if I can follow this on GitHub or some other tracking system, that would be great.

Thanks!
-MikeD
