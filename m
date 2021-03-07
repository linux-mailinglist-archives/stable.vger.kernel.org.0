Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C05E0330231
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 15:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbhCGOpk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 09:45:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:53148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230432AbhCGOpS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 09:45:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6404650E7;
        Sun,  7 Mar 2021 14:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615128318;
        bh=YCw4018zw2KcCSsyqZtvG0Nisb/g0kfVcawRLUa6+IE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fjTIpBEIHdqCdsysdsocIwD9kRlj6cDVzbxjtxkuVQqwU6QAWt3d4SSJTAopwkANB
         FstWUK245ae6qlU33+qTTPvIp7qAppeNMy5ZJtDxsfa+ROOfMVmPcCdxidd3U/yevK
         pjrq/xnsI6qbwr3g7WkOBmjT3RXY8Bef3UsM/es0=
Date:   Sun, 7 Mar 2021 15:45:15 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        Ronald Warsow <rwarsow@gmx.de>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: stable kernel checksumming fails
Message-ID: <YETm+6sQqek6kY/A@kroah.com>
References: <d58ab27a-78ad-1119-79ac-2a1fbcd3527a@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d58ab27a-78ad-1119-79ac-2a1fbcd3527a@gmx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 07, 2021 at 03:10:49PM +0100, Ronald Warsow wrote:
> hello
> 
> getting stable kernels with this script:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/mricon/korg-helpers.git/tree/get-verified-tarball
> 
> 
> fails since the last 2 (?) stable releases with (last lines):
> 
> ...
> 
> + /usr/bin/curl -L -o
> /home/ron/Downloads/linux-tarball-verify.1GiZid5WT.untrusted/linux-5.11.4.tar.xz
> https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.11.4.tar.xz
>   % Total    % Received % Xferd  Average Speed   Time    Time     Time
> Current
>                                  Dload  Upload   Total   Spent    Left
> Speed
> 100  112M  100  112M    0     0  5757k      0  0:00:19  0:00:19 --:--:--
> 5938k
> 
> pushd ${TMPDIR} >/dev/null
> + pushd /home/ron/Downloads/linux-tarball-verify.1GiZid5WT.untrusted
> echo "Verifying checksum on linux-${VER}.tar.xz"
> + echo 'Verifying checksum on linux-5.11.4.tar.xz'
> Verifying checksum on linux-5.11.4.tar.xz
> if ! ${SHA256SUMBIN} -c ${SHACHECK}; then
>     echo "FAILED to verify the downloaded tarball checksum"
>     popd >/dev/null
>     rm -rf ${TMPDIR}
>     exit 1
> fi
> + /usr/bin/sha256sum -c
> /home/ron/Downloads/linux-tarball-verify.1GiZid5WT.untrusted/sha256sums.txt
> /usr/bin/sha256sum:
> /home/ron/Downloads/linux-tarball-verify.1GiZid5WT.untrusted/sha256sums.txt:
> no properly formatted SHA256 checksum lines found
> + echo 'FAILED to verify the downloaded tarball checksum'
> FAILED to verify the downloaded tarball checksum
> + popd
> + rm -rf /home/ron/Downloads/linux-tarball-verify.1GiZid5WT.untrusted
> + exit 1
> 
> 
> checksumming the downloaded kernel manually gives an "Okay" though.
> 
> 
> is this just me (on Fedora 33) ?

Fails for me on Arch:

Verifying checksum on linux-5.11.4.tar.xz
/usr/bin/sha256sum: /home/gregkh/Downloads/linux-tarball-verify.gZo313NCk.untrusted/sha256sums.txt: no properly formatted SHA256 checksum lines found
FAILED to verify the downloaded tarball checksum


Konstantin, anything change recently?

