Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27E45C2974
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 00:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfI3W0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Sep 2019 18:26:14 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33626 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbfI3W0N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Sep 2019 18:26:13 -0400
Received: by mail-pl1-f195.google.com with SMTP id d22so4454462pls.0
        for <stable@vger.kernel.org>; Mon, 30 Sep 2019 15:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=message-id:mime-version:content-transfer-encoding:in-reply-to
         :references:from:to:cc:subject:user-agent:date;
        bh=gNsbryt7zNBbao6S6XuAFO6RWtb7mB6GkwvJUITq7vM=;
        b=FEXFmDSWmj9zN3ls+08cfHJNs9Lsa2F0tEzABAFOuqGbjQROJS6TNJU5LLLV8Qf6Yw
         +kkcd6TuvfCWfghRPjvVmC458yCnJNKvq1bpGzjnfNSIZnaZ1Xc62B67lrYXSeW2vUp0
         ZKyOdm+DwVGgaOV2BTZyedDwuc/YgjOZprM94=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:mime-version
         :content-transfer-encoding:in-reply-to:references:from:to:cc:subject
         :user-agent:date;
        bh=gNsbryt7zNBbao6S6XuAFO6RWtb7mB6GkwvJUITq7vM=;
        b=QnbZpuhIiWWwcYsN33QJX614pK6HlV6Eah4l+/y7hg287VFl+RAHWEGPi/WfWmINIy
         HMDcq1shmFlAdXIcKgw667Q14uEj2x5w45fWLam1LR8gaw4DTLL6Y3CffuvZxmD97R0n
         zuYQGn9+LmnRwkcptbRGwR/JwHlSM0MfVKeUjyiWyKjo7lrg9ggOImFPX/1+A7IUp+Qe
         LcDWuOkBCuxUsdBGdScsv47PJ7XRMCoFFVo5VVYitYyR/PYItllczFTNAS/fwaIcFX1C
         jZpQQ5oSB6grZ3d1wUMW0cz4WEXUy9DIXYLGNkCPPz1YDsxsV8Sg8iCF17RrOnngz+R1
         YoIA==
X-Gm-Message-State: APjAAAXKCD+9LkH/n37UlgTVivEAu2fjCJpRupGbwKQNPJ+/PMWsoO9X
        nzJjrzn71fPwyBbVVNw9/ErOww==
X-Google-Smtp-Source: APXvYqyvW7KnD4p6RRzMyQjVNhtlhTTZF+raYHO8fe9TpmKW4CBZvkZUT8KHrNro7nlOT/UpLtas9g==
X-Received: by 2002:a17:902:aa04:: with SMTP id be4mr14295817plb.40.1569882373177;
        Mon, 30 Sep 2019 15:26:13 -0700 (PDT)
Received: from chromium.org ([2620:15c:202:1:fa53:7765:582b:82b9])
        by smtp.gmail.com with ESMTPSA id l37sm8474089pgb.11.2019.09.30.15.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 15:26:12 -0700 (PDT)
Message-ID: <5d928104.1c69fb81.29df9.6eef@mx.google.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20190930214522.240680-1-briannorris@chromium.org>
References: <20190930214522.240680-1-briannorris@chromium.org>
From:   Stephen Boyd <swboyd@chromium.org>
To:     Brian Norris <briannorris@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Hung-Te Lin <hungte@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        stable@vger.kernel.org, Guenter Roeck <groeck@chromium.org>
Subject: Re: [PATCH] firmware: google: increment VPD key_len properly
User-Agent: alot/0.8.1
Date:   Mon, 30 Sep 2019 15:26:11 -0700
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Brian Norris (2019-09-30 14:45:22)
> Commit 4b708b7b1a2c ("firmware: google: check if size is valid when
> decoding VPD data") adds length checks, but the new vpd_decode_entry()
> function botched the logic -- it adds the key length twice, instead of
> adding the key and value lengths separately.
>=20
> On my local system, this means vpd.c's vpd_section_create_attribs() hits
> an error case after the first attribute it parses, since it's no longer
> looking at the correct offset. With this patch, I'm back to seeing all
> the correct attributes in /sys/firmware/vpd/...
>=20
> Fixes: 4b708b7b1a2c ("firmware: google: check if size is valid when decod=
ing VPD data")
> Cc: <stable@vger.kernel.org>
> Cc: Hung-Te Lin <hungte@chromium.org>
> Cc: Guenter Roeck <groeck@chromium.org>
> Cc: Stephen Boyd <swboyd@chromium.org>
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---

Reviewed-by: Stephen Boyd <swboyd@chromium.org>

