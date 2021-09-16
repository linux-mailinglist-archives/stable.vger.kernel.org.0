Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00DAB40D106
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 02:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbhIPA5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 20:57:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233393AbhIPA5c (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 20:57:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0811610D1;
        Thu, 16 Sep 2021 00:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631753773;
        bh=pgnKBG0IkPmD5mHwnJGP4MO9grHBDDzdzGVxl2qC78U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u4MqB+Ol2Pu2+kDVyTXIumMPFx3phXhiXNm1EUAkGf7H0szTpY3eW4bWlBRbHUFkW
         ErHNFPq6capQGoryArp9v1M7R3E6T6fKCBoKCVrpHrosYUZ7fksMHMGjpXBrO4C5/I
         gMHis44MCQ/bG/nJd3Qldt9rVHXILfn1fxCP8fdNpupS5VPX4P20wLYzNkBZzj1P6+
         21uX+nHtHkKhXayodDGiAa4yhBN0Y1TW5EFS35eeIhzrpvSL+D8AhkoFUHkQjZZbA1
         Ex86rQKD7wvp4IIDeeFBKJbsvF8rOZ6GlnwPZrf+Ng0SB4TOv9y4OqcTvJ5LsLkL1B
         Wa9IgE2aSDNyg==
Date:   Wed, 15 Sep 2021 20:56:11 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Mattijs Korpershoek <mkorpershoek@baylibre.com>
Subject: Re: [PATCH 5.10 157/236] Bluetooth: Move shutdown callback before
 flushing tx and rx queue
Message-ID: <YUKWK4EflIdFxFsp@sashalap>
References: <20210913131100.316353015@linuxfoundation.org>
 <20210913131105.720088593@linuxfoundation.org>
 <20210915111843.GA16198@duo.ucw.cz>
 <20210915143238.GA2403125@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210915143238.GA2403125@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 15, 2021 at 07:32:38AM -0700, Guenter Roeck wrote:
>On Wed, Sep 15, 2021 at 01:18:43PM +0200, Pavel Machek wrote:
>> Hi!
>>
>> > [ Upstream commit 0ea53674d07fb6db2dd7a7ec2fdc85a12eb246c2 ]
>>
>> Upstream commit is okay...
>>
>> > So move the shutdown callback before flushing TX/RX queue to resolve the
>> > issue.
>>
>> ...but something went wrong in stable. This is not moving code, this
>> is duplicating it:
>>
>> > --- a/net/bluetooth/hci_core.c
>> > +++ b/net/bluetooth/hci_core.c
>> > @@ -1726,6 +1726,14 @@ int hci_dev_do_close(struct hci_dev *hdev)
>> >  	hci_request_cancel_all(hdev);
>> >  	hci_req_sync_lock(hdev);
>> >
>> > +	if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
>> > +	    !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
>> > +	    test_bit(HCI_UP, &hdev->flags)) {
>> > +		/* Execute vendor specific shutdown routine */
>> > +		if (hdev->shutdown)
>> > +			hdev->shutdown(hdev);
>> > +	}
>> > +
>> >  	if (!test_and_clear_bit(HCI_UP, &hdev->flags)) {
>> >  		cancel_delayed_work_sync(&hdev->cmd_timer);
>> >  		hci_req_sync_unlock(hdev);
>>
>> And yes, we end up with 2 copies in 5.10.
>>
>
>Same problem in v5.4.y, unfortunately.

Ugh, odd - it wasn't manually backported :/

I'll drop it.

-- 
Thanks,
Sasha
