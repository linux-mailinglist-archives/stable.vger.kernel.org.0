Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E489CC543
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 23:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730855AbfJDVyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 17:54:24 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:44228 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730283AbfJDVyY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 17:54:24 -0400
Received: by mail-lf1-f67.google.com with SMTP id q12so516204lfc.11
        for <stable@vger.kernel.org>; Fri, 04 Oct 2019 14:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zoPNMzdQSsaX6T9xeXeKifKMZMvmutkXru6+TSI0b7Y=;
        b=wPWEuKlFUYzqdz4qs+FuWOkgujk6xQg4W88Gbwdt69yuCS4wF7jXBJ4GRPkZgyv8Kn
         gK3sYtTACAkkDIUWPIZxxu/0w1Eg23rseLUrwOcuHfzFts5eaU2ossk8ApAjQMalVPBh
         v/j+CjSbylx2eql609qx6b5pr/aMdpGxO+GwWP5fJlJL0YOCSX+tr4e5YbT0x/k5AWzK
         SwQVCCveut9k7OqNDYdHhgBL00/dvo11ApelQlPEGNEN2wE56jYEVWfGecor/prMr+fw
         blM71t5HKQTpeN7ZQUyQfoi0MuHKD/nGja/CpKC9T8UldLJFGLerfT0g3clJhEkHa6Uq
         tB3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zoPNMzdQSsaX6T9xeXeKifKMZMvmutkXru6+TSI0b7Y=;
        b=Qxo+TfuaFitFXWUC/Ep292y5WKJ/40TI6RZ8t9Hiu8ipWC3Ccbm0tIWLxyJTpmbADv
         acWOWb3CM/l/2jaMwbLOeHzBhPB1KVOFsqTZB50xP2FHkjBMM5tPr3SEfmZSgXsZDgRP
         PFVRYa8OBPbVWcoiq32ZRAw6T+GtKvDWrivYciVo3a3INk8Z2fG1y3NEwrPr1aYHmiIH
         aUokJ5wskbWyydpa3AGxUuvR/3v6yzjfmzlF+kWvuAu840JbD3sVPvRGTn1vVoEFidq6
         S3qe1b4gHPPsnPhD3zbss4Q4ioq02oxp/wCA6jOQnykXbx4x//9l2Pm1tdEv6kJe0QBZ
         RggQ==
X-Gm-Message-State: APjAAAXlKSoatow+c49IMdEXMKtECY1H7csaUGsWB6J+5npVLbNoacvx
        s2haQztsJlUZRMPULMsAmENeIshl2LnxZC+SAob+gA==
X-Google-Smtp-Source: APXvYqws72vP4SKYhJ249ciHl03mUZyS9feS1uY1gUxq8IxgZYM6e4vR28Xp5ay5FGaGgDRYYJMV4A6rfFLyAwnEyp4=
X-Received: by 2002:a19:117:: with SMTP id 23mr10232144lfb.115.1570226062105;
 Fri, 04 Oct 2019 14:54:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190618160105.26343-3-alpawi@amazon.com> <20191001154634.96165-1-alpawi@amazon.com>
In-Reply-To: <20191001154634.96165-1-alpawi@amazon.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 4 Oct 2019 23:54:10 +0200
Message-ID: <CACRpkdY7bYBytGq-AnMrRVWn=-ASz=xTA-_-5wCfsymch4qW9A@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: armada-37xx: fix control of pins 32 and up
To:     Patrick Williams <alpawi@amazon.com>
Cc:     Patrick Williams <patrick@stwcx.xyz>,
        stable <stable@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 1, 2019 at 5:49 PM Patrick Williams <alpawi@amazon.com> wrote:

> The 37xx configuration registers are only 32 bits long, so
> pins 32-35 spill over into the next register.  The calculation
> for the register address was done, but the bitmask was not, so
> any configuration to pin 32 or above resulted in a bitmask that
> overflowed and performed no action.
>
> Fix the register / offset calculation to also adjust the offset.
>
> Fixes: 5715092a458c ("pinctrl: armada-37xx: Add gpio support")
> Signed-off-by: Patrick Williams <alpawi@amazon.com>
> Acked-by: Gregory CLEMENT <gregory.clement@bootlin.com>
> Cc: <stable@vger.kernel.org>

Patch applied for fixes.

Yours,
Linus Walleij
