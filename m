Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2EF4799C8
	for <lists+stable@lfdr.de>; Sat, 18 Dec 2021 09:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbhLRI4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Dec 2021 03:56:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232378AbhLRI4E (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Dec 2021 03:56:04 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9770C061574
        for <stable@vger.kernel.org>; Sat, 18 Dec 2021 00:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=hSgtc8h/M/z51yQ8AYw27NsQpOuduE7OtPSsiZsOv/k=;
        t=1639817763; x=1641027363; b=FMl7WSCL+wDUnLw6QTTlO8nwNEn8Y7Y2ALPZS+NAFwDc9mD
        wdibbZyihJsT9sP3coErKqhK5dfXHSIdROcsYB+XcZm5eJbiSaM6lYylZxUYUdeUhz2m6r3CZEolS
        Krx57tPUiIsyiXc3U6q52dUFKf9F+IuDW2evzOsl07mQGkruJrdXLQViR98UWPRHp37Gog4eFcwof
        LOE0b9xBi1/4IjYiDM3KwFumoh3mh5Vqhf7cmedCdtuYCVz5d2gxau/IrSqA6WcEobPIUuKlCR38W
        aMr4oSeVx1fVd0SRZHOXTunAXHOGxVJLFdTsitGgG5lsiR3jBmcHs1VZth/1tdfw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1myVVZ-00D7ui-4g;
        Sat, 18 Dec 2021 09:56:01 +0100
Message-ID: <d224b7c664182221bc2209ce5107ff3fd65be9d3.camel@sipsolutions.net>
Subject: Re: [PATCH v4.19 1/2] mac80211: mark TX-during-stop for TX in
 in_reconfig
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Sat, 18 Dec 2021 09:56:00 +0100
In-Reply-To: <Yb0e8mSZZT0jxgSl@kroah.com>
References: <20211217203550.54684-1-johannes@sipsolutions.net>
         <3ce00af3568e08d25b88ba9c7d27638d95c95536.camel@sipsolutions.net>
         <Yb0e8mSZZT0jxgSl@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 2021-12-18 at 00:36 +0100, Greg KH wrote:
> 
> Yeah, I don't think it's needed, but as it was marked to go back really
> far, I wanted to give you the option to do so or not.
> 

Yeah I marked it because I'm pretty sure that problem _was_ introduced
that far back with the TXQ code, but OTOH I'm not even sure initially it
had users there, and then users that would run into the restart issue
... probably not, otherwise I'd think we'd have heard about it earlier?

Backporting the IEEE80211_TXQ_STOP_NETIF_TX stuff doesn't seem that
problematic either, but I'm not convinced it's worth it, and I suppose
somebody whose driver actually uses it on those kernels would better
take a look - I'm not familiar with all the drivers in detail, and
iwlwifi doesn't use it yet there.

johannes
