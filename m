Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBF4419624
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 16:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234717AbhI0OWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 10:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234690AbhI0OW2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 10:22:28 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6262DC061575;
        Mon, 27 Sep 2021 07:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=eOvgrhpxN9OxQ688askyKJoBpK1KwuAfg2w4kS25LTE=;
        t=1632752450; x=1633962050; b=yAeCSf0QyuInxUdse30wxb5qVa3dWzONJpzq54xaxEoU/8m
        UxxPeD1e8WVAcmeR6hBG9eiGd8giJ+VAh2MJQSLlK4SpVspxx2i9lIhJNbYX8tjRmGVam+IpHb4GL
        64C3d+VHIKNIOHPVpwzq8aTr0V54nKtjUL0AVmnhm/PTDpgKY+A46WOFbIoOTS6gkcYgyUdJ6Wh8Q
        M7jIHKMfZpt+rseyKHkx1+SwA0MszKMlHFdLSmwhUVPzNww1Jj1Barlji7wC7oWybrBHDSSu5EVuD
        hm4bDM3pDCWCuE+LosH8emZ7olsVg0oTlx9mL4/sqwaLPggodd3UX9Fnw2vvZL6A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95-RC2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mUrUt-00CSGB-SC;
        Mon, 27 Sep 2021 16:20:47 +0200
Message-ID: <97300681a8e793b71ccedf8224010f1f64da6b5c.camel@sipsolutions.net>
Subject: Re: [PATCH] leds: trigger: use RCU to protect the led_cdevs list
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date:   Mon, 27 Sep 2021 16:20:47 +0200
In-Reply-To: <20210927141619.GA18276@duo.ucw.cz>
References: <20210915181601.99a68f5718be.I1a28b342d2d52cdeeeb81ecd6020c25cbf1dbfc0@changeid>
         <20210927141619.GA18276@duo.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Pavel,

> > 
> > Cc: stable@vger.kernel.org
> 
> I ... don't like idea of this going to stable.

OK, I guess that's fair. We've been running into the lockdep report for
a while - ever since we made the spinlock in iwlwifi no longer disable
IRQs all the time, which was meant to be a good thing ...

However, the scenario that could cause *real* deadlocks there is really
unlikely and requires four CPUs all doing the exactly right thing,
including a normally very rare *write lock* on the leddev_list_lock, so
I don't think in practice it'll be much of an issue.

johannes



