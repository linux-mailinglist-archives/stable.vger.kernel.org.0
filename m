Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A58C05C6D6
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 03:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfGBB4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 21:56:36 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41209 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbfGBB4g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jul 2019 21:56:36 -0400
Received: by mail-pf1-f194.google.com with SMTP id m30so7428056pff.8
        for <stable@vger.kernel.org>; Mon, 01 Jul 2019 18:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appneta.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=stN/jIcTtxkt6RabqwrSWPJaiRnq2+3A1E/0aRNbIVM=;
        b=qqBUbhvJ0LOwiVbEXfdDBe/HVEYqlx2/QoFVPRd/aREc2aplfnzuDV33TSY8qORmzR
         h5KNux9TsYrU+KnPyS2D2gan81KJ3k+jsEqHbbX9mocR7T5/bCFm8zStgyNfZ7i3kYfB
         6J8g6VzJWr/mYKxn+b2dXRWXOU+Q4sXHcuvzw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=stN/jIcTtxkt6RabqwrSWPJaiRnq2+3A1E/0aRNbIVM=;
        b=p1UweF+7Sv7R3hEJENcxnitwkfuAy3vGVe1M3hR3c3EJLbZ7phdWkPBDvB/xgyWIw1
         0wUMbP+B6rYfcI6MxeGI68xL524rQCcU4UdbOIlZRxwSyOufJauiXvID7G8Zp7NPbQJ6
         WkZptcUvjMM8bvlI+fDVeySqxJEDAY7XstFmTTvsmIywFzIXpA2Dr0jx1AeMwYBZwr8/
         1hEfvxyk48zLMXwcQCo6bFlCsDuxRXvvvW338+5KTTJ7qWbY6d3aIbxordHJR1MnKtEu
         LFOPHDQWokHTOK6B5HQ/aTm+n3h7il1oDASLnLf0oVrgiTNDYn27WOjhSBWCm5tcIrCP
         64HA==
X-Gm-Message-State: APjAAAUS0VKCyY3hbEzRk/BCWB0Xa1P/3No5dIvTzsgDX+0M1ALh22jD
        /NmPQ6vm8A7oZOtns03qL1nd
X-Google-Smtp-Source: APXvYqwrYsK/dMW3rmcYM9cn7fBU79CkEgcA3NY8e9ZMu60O5v89syAMOxOqc1+RIddGd4bp1Ah5sg==
X-Received: by 2002:a63:f50d:: with SMTP id w13mr27794200pgh.411.1562032595919;
        Mon, 01 Jul 2019 18:56:35 -0700 (PDT)
Received: from [192.168.1.144] (64-46-6-129.dyn.novuscom.net. [64.46.6.129])
        by smtp.gmail.com with ESMTPSA id n26sm12435679pfa.83.2019.07.01.18.56.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 18:56:35 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH RESEND 4.9.y] net: check before dereferencing netdev_ops
 during busy poll
From:   Josh Elsasser <jelsasser@appneta.com>
In-Reply-To: <20190701.185156.2142325894415755085.davem@davemloft.net>
Date:   Mon, 1 Jul 2019 18:56:32 -0700
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, edumazet@google.com, mcroce@redhat.com
Content-Transfer-Encoding: 7bit
Message-Id: <84C901BF-9CA7-4A5F-9CC7-EE095EA043A5@appneta.com>
References: <20190701234143.72631-1-jelsasser@appneta.com>
 <20190701.185156.2142325894415755085.davem@davemloft.net>
To:     David Miller <davem@davemloft.net>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Jul 1, 2019, at 6:51 PM, David Miller <davem@davemloft.net> wrote:

> I just tried to apply this with "git am" to the current v4.19 -stable
> branch and it failed.

This is only needed for the v4.9 stable kernel, ndo_busy_poll (and this NPE) 
went away in kernel 4.11.

Sorry, I probably should have called that out more explicitly.

