Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16FD0ADCD9
	for <lists+stable@lfdr.de>; Mon,  9 Sep 2019 18:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbfIIQOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 12:14:04 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37774 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726472AbfIIQOE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Sep 2019 12:14:04 -0400
Received: by mail-pf1-f195.google.com with SMTP id y5so6714212pfo.4
        for <stable@vger.kernel.org>; Mon, 09 Sep 2019 09:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MKRKebMQp8+SbILfMU8ecMqIsBhud1/TN1PMbu5EjjI=;
        b=imxIhVk5aoekCjb3KrtkWUiDJG9zxpKIE771OqRjLKCUU5dIADhAa6wXm0FY6+YtDF
         VCz/+iFQxpMJz/eejN+BtKQWxzSBWU5Xq6jCCo3dlJRkvDYeCw80LJoyhXngUTW1Ltz7
         F4PEOrXFIgE8XECGTNyTooYBhKEHd1LlHLq1Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MKRKebMQp8+SbILfMU8ecMqIsBhud1/TN1PMbu5EjjI=;
        b=j00TMni3u9OgyTPKcVuf/Ro4vNf1VJDb+nZfk3RGOBIaIe/F32iSpZa/9EvCrprTrr
         h0/R4OL7AMWxLCGHKlVGkLQDVJp+FOoQEzDx91O1X90SfRnmEEn0xzUQ3wmCDagG4rko
         MZZVCrgxaLa0K7dzJESPZlCH4/DWMCs1I2l5amso4one5SXp9/mhaboKMu/nG0Nk8F8A
         3CvHnuuiXxKAoVRqNN4t+ee8K3V2KscNTBot3gtI1Zp6pzTBZxTs2p1WRy8kmcvEkv9D
         EnTzzm5qFeswxrDGZywPvLiJjlKFoFT41nxCjgJb6BjDXHMrBeMcCBOLZrz3FLyxo/z7
         jjEA==
X-Gm-Message-State: APjAAAXo8yvHgYtEobxnbd3x48eeWpQ6LPttEqSnoyrEAxDtnVgxTwHF
        Y9mGalbsP3a+fLvQN8deldElSg==
X-Google-Smtp-Source: APXvYqxv0uRHIjWCqUuwfqWyNKlXfBanrG+Rix/cvYZZTS2khVb7BokyP3a1CE29ekh+2DNFWd0/lA==
X-Received: by 2002:a63:3281:: with SMTP id y123mr21806450pgy.72.1568045643654;
        Mon, 09 Sep 2019 09:14:03 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id j1sm14982164pgl.12.2019.09.09.09.14.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Sep 2019 09:14:02 -0700 (PDT)
Date:   Mon, 9 Sep 2019 09:13:59 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.14 04/40] Bluetooth: btqca: Add a short delay before
 downloading the NVM
Message-ID: <20190909161359.GE133864@google.com>
References: <20190908121114.260662089@linuxfoundation.org>
 <20190908121115.297090022@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190908121115.297090022@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 08, 2019 at 01:41:37PM +0100, Greg Kroah-Hartman wrote:
> [ Upstream commit 8059ba0bd0e4694e51c2ee6438a77b325f06c0d5 ]
> 
> On WCN3990 downloading the NVM sometimes fails with a "TLV response
> size mismatch" error:
> 
> [  174.949955] Bluetooth: btqca.c:qca_download_firmware() hci0: QCA Downloading qca/crnv21.bin
> [  174.958718] Bluetooth: btqca.c:qca_tlv_send_segment() hci0: QCA TLV response size mismatch

WC3990 support was only added in 4.19, so this shouldn't be needed in
older kernels, but it shouldn't do any harm either ;-)

> It seems the controller needs a short time after downloading the
> firmware before it is ready for the NVM. A delay as short as 1 ms
> seems sufficient, make it 10 ms just in case. No event is received
> during the delay, hence we don't just silently drop an extra event.
> 
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/bluetooth/btqca.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
> index 0bbdfcef2aa84..a48a61f22f823 100644
> --- a/drivers/bluetooth/btqca.c
> +++ b/drivers/bluetooth/btqca.c
> @@ -363,6 +363,9 @@ int qca_uart_setup_rome(struct hci_dev *hdev, uint8_t baudrate)
>  		return err;
>  	}
>  
> +	/* Give the controller some time to get ready to receive the NVM */
> +	msleep(10);
> +
>  	/* Download NVM configuration */
>  	config.type = TLV_TYPE_NVM;
>  	snprintf(config.fwname, sizeof(config.fwname), "qca/nvm_%08x.bin",
