Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B03E1053A9
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 14:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfKUN4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 08:56:04 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40010 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbfKUN4E (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 08:56:04 -0500
Received: by mail-lj1-f193.google.com with SMTP id q2so3324055ljg.7
        for <stable@vger.kernel.org>; Thu, 21 Nov 2019 05:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mwVumWvJHo4zvWxGZJD9YSWEBNd/DEDoZWc1zGQkww4=;
        b=PROaNuWrUKfIWxlt+j8KnAB87S9sEPRRC6XBWLZRSlLDbSCwpFFGXYtL+n3UhxkSnb
         zltboWUsjHwVXDG8sa1sM8NgJaHgZF4KeCpIkdAaZyRqZqCaHl+rYRUm3D8RS5A/EnCl
         Q75Zxx34KXOEIEj224cI+oGu1NFCGs7vdCaqpWbgqyBMpoIU0Aj/VrIffmL6710odHKO
         gULu3ssd8wX29tDvOdwwoYjcU1hc1jN7CkusvCk3jWPw22fId0+TqKLIYq975QXn+C2a
         qYZgtmLDvAJ/JMwbYbfP/gEoCc7fbYXQ3sWQZXg3offSocrRzpuPbKzNbGwTNdfiIcNQ
         +jFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mwVumWvJHo4zvWxGZJD9YSWEBNd/DEDoZWc1zGQkww4=;
        b=NMIxqY/ZgHfS4vJudbJfI1srLZLSNlw0/acW/G9VLv6SaFz7px/XwC8CgSjPaPGfUL
         mMFIM3OAH7PCGK9OHhaDkvKGTX1sm4OL5aX+sLjT3Gsb2ZOs6ULwNKcFVsvUh3aPxLml
         6iki423KE8LRjVfexUpB/N3c+7Qt2UTpQkaflMAtJw2eWrUIlclsYfINDxAvB0ofXkPY
         uXFIDRuNDVzE/v7JkKEwhzFj+Wi8noc3CyMHq3tYqk8p00ROdTzoxMobuO+ztbnO+2G2
         sPqZL2tnWdvhgCSoDCe23jT09wKWEqYvpS7VDuR2qJSO5M0QaQFWcYfHlbc1XTaO9FiV
         z5aA==
X-Gm-Message-State: APjAAAV6IsNy0CC8MNS5Yn/uqZi3xatrSqo3nVi7E9VxRYJMBOREpZYz
        sNGUzJdNvbnNtdEsXyoE4dD7i6ZZvu2284SwIFRmUA==
X-Google-Smtp-Source: APXvYqxK0E9D55XX4sJlFFn/xkAOM+O9uzYS51IiYbmsrxiwLu/M4n5FQGZais+eCToXwuxAaBgFfC8+x3EE7MMm9YU=
X-Received: by 2002:a2e:9784:: with SMTP id y4mr7671826lji.77.1574344562426;
 Thu, 21 Nov 2019 05:56:02 -0800 (PST)
MIME-Version: 1.0
References: <20191115155752.2562-1-gregory.clement@bootlin.com>
In-Reply-To: <20191115155752.2562-1-gregory.clement@bootlin.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 21 Nov 2019 14:55:51 +0100
Message-ID: <CACRpkda5m-h_v_aNGb5gAOH7-HSd5c+Oxdij=H3UwQG9-FusaQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: armada-37xx: Fix irq mask access in armada_37xx_irq_set_type()
To:     Gregory CLEMENT <gregory.clement@bootlin.com>
Cc:     "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        stable <stable@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 15, 2019 at 4:58 PM Gregory CLEMENT
<gregory.clement@bootlin.com> wrote:

> As explained in the following commit a9a1a4833613 ("pinctrl:
> armada-37xx: Fix gpio interrupt setup") the armada_37xx_irq_set_type()
> function can be called before the initialization of the mask field.
>
> That means that we can't use this field in this function and need to
> workaround it using hwirq.
>
> Fixes: 30ac0d3b0702 ("pinctrl: armada-37xx: Add edge both type gpio irq support")
> Cc: stable@vger.kernel.org
> Reported-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>

Patch applied.

I do not have time to send any more fixes pull requests at this
point, so this will go into v5.5 in the merge window with everything
else, and then to stable from there.

Yours,
Linus Walleij
