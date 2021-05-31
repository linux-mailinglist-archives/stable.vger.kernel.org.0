Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7193E3959EB
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 13:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhEaL4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 07:56:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231245AbhEaL4Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 07:56:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7015860FEB;
        Mon, 31 May 2021 11:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622462076;
        bh=88cQLEtHKrsPxflkTMZSzj0DKy02IWF2RMfFHmyg9ns=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a7mL6qT1h7I5MEbfp2SC+sCFm82qRhjdiP+Mdzhm8+oHuIXTcRPGZVhXUeiAhlxlm
         Lxvl9vHVbIRfXEcO3lrcu/fZU1pLRZSJavZfF+AnMmgWgP48eeljwUVemmDKoLK3oA
         +zkGy4YXCFbMf3Imbm5j66g3RcpmhyWBcy39SwF8=
Date:   Mon, 31 May 2021 13:54:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        Lin Ma <linma@zju.edu.cn>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH for 4.4] bluetooth: eliminate the potential race
 condition when removing the HCI controller
Message-ID: <YLTOeqxO5j7DigUU@kroah.com>
References: <20210528085224.1021277-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210528085224.1021277-1-nobuhiro1.iwamatsu@toshiba.co.jp>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 28, 2021 at 05:52:24PM +0900, Nobuhiro Iwamatsu wrote:
> From: Lin Ma <linma@zju.edu.cn>
> 
> commit e2cb6b891ad2b8caa9131e3be70f45243df82a80 upstream.
> 
> There is a possible race condition vulnerability between issuing a HCI
> command and removing the cont.  Specifically, functions hci_req_sync()
> and hci_dev_do_close() can race each other like below:
> 
> thread-A in hci_req_sync()      |   thread-B in hci_dev_do_close()
>                                 |   hci_req_sync_lock(hdev);
> test_bit(HCI_UP, &hdev->flags); |
> ...                             |   test_and_clear_bit(HCI_UP, &hdev->flags)
> hci_req_sync_lock(hdev);        |
>                                 |
> In this commit we alter the sequence in function hci_req_sync(). Hence,
> the thread-A cannot issue th.
> 
> Signed-off-by: Lin Ma <linma@zju.edu.cn>
> Cc: Marcel Holtmann <marcel@holtmann.org>
> Fixes: 7c6a329e4447 ("[Bluetooth] Fix regression from using default link policy")
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [iwamatsu: adjust filename, arguments of __hci_req_sync(). CVE-2021-32399]
> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
> ---
>  net/bluetooth/hci_core.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)

Now queued up, thanks.

greg k-h
