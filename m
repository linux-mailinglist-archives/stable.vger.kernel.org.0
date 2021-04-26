Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B8836B756
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 18:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234257AbhDZQ7Z convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 26 Apr 2021 12:59:25 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:48737 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233736AbhDZQ7Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 12:59:25 -0400
X-Greylist: delayed 405 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Apr 2021 12:59:25 EDT
Received: from marcel-macbook.holtmann.net (p4fefc624.dip0.t-ipconnect.de [79.239.198.36])
        by mail.holtmann.org (Postfix) with ESMTPSA id 60165CECEA;
        Mon, 26 Apr 2021 18:59:45 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH v2] Bluetooth: Make spurious error message debug
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210426144419.451157-1-szymon.janc@codecoup.pl>
Date:   Mon, 26 Apr 2021 18:51:56 +0200
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        stable@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <68043295-4E52-4C3C-9023-B7FC272072B6@holtmann.org>
References: <20210426144419.451157-1-szymon.janc@codecoup.pl>
To:     Szymon Janc <szymon.janc@codecoup.pl>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Szymon,

> Even with rate limited reporting this is very spammy and since
> it is remote device that is providing bogus data there is no
> need to report this as error.
> 
> [72454.143336] bt_err_ratelimited: 10 callbacks suppressed
> [72454.143337] Bluetooth: hci0: advertising data len corrected
> [72454.296314] Bluetooth: hci0: advertising data len corrected
> [72454.892329] Bluetooth: hci0: advertising data len corrected
> [72455.051319] Bluetooth: hci0: advertising data len corrected
> [72455.357326] Bluetooth: hci0: advertising data len corrected
> [72455.663295] Bluetooth: hci0: advertising data len corrected
> [72455.787278] Bluetooth: hci0: advertising data len corrected
> [72455.942278] Bluetooth: hci0: advertising data len corrected
> [72456.094276] Bluetooth: hci0: advertising data len corrected
> [72456.249137] Bluetooth: hci0: advertising data len corrected
> [72459.416333] bt_err_ratelimited: 13 callbacks suppressed
> [72459.416334] Bluetooth: hci0: advertising data len corrected
> [72459.721334] Bluetooth: hci0: advertising data len corrected
> [72460.011317] Bluetooth: hci0: advertising data len corrected
> [72460.327171] Bluetooth: hci0: advertising data len corrected
> [72460.638294] Bluetooth: hci0: advertising data len corrected
> [72460.946350] Bluetooth: hci0: advertising data len corrected
> [72461.225320] Bluetooth: hci0: advertising data len corrected
> [72461.690322] Bluetooth: hci0: advertising data len corrected
> [72462.118318] Bluetooth: hci0: advertising data len corrected
> [72462.427319] Bluetooth: hci0: advertising data len corrected
> [72464.546319] bt_err_ratelimited: 7 callbacks suppressed
> [72464.546319] Bluetooth: hci0: advertising data len corrected
> [72464.857318] Bluetooth: hci0: advertising data len corrected
> [72465.163332] Bluetooth: hci0: advertising data len corrected
> [72465.278331] Bluetooth: hci0: advertising data len corrected
> [72465.432323] Bluetooth: hci0: advertising data len corrected
> [72465.891334] Bluetooth: hci0: advertising data len corrected
> [72466.045334] Bluetooth: hci0: advertising data len corrected
> [72466.197321] Bluetooth: hci0: advertising data len corrected
> [72466.340318] Bluetooth: hci0: advertising data len corrected
> [72466.498335] Bluetooth: hci0: advertising data len corrected
> [72469.803299] bt_err_ratelimited: 10 callbacks suppressed
> 
> Signed-off-by: Szymon Janc <szymon.janc@codecoup.pl>
> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=203753
> Cc: stable@vger.kernel.org
> ---
> net/bluetooth/hci_event.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 5e99968939ce..2a27d5764ba0 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -5476,8 +5476,8 @@ static void process_adv_report(struct hci_dev *hdev, u8 type, bdaddr_t *bdaddr,
> 
> 	/* Adjust for actual length */
> 	if (len != real_len) {
> -		bt_dev_err_ratelimited(hdev, "advertising data len corrected %u -> %u",
> -				       len, real_len);
> +		bt_dev_dbg(hdev, "advertising data len corrected %u->%u",
> +			   len, real_len);
> 		len = real_len;
> 	}

then don’t even bother with bt_dev_dbg either. That is also just eating up cycles.

Regards

Marcel

