Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1212389FAE
	for <lists+stable@lfdr.de>; Mon, 12 Aug 2019 15:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbfHLN2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Aug 2019 09:28:44 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38776 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbfHLN2o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Aug 2019 09:28:44 -0400
Received: by mail-wm1-f66.google.com with SMTP id m125so7717323wmm.3
        for <stable@vger.kernel.org>; Mon, 12 Aug 2019 06:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linbit-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bTg0D8gCcPG/JWmmX96yNXeO3DHquJW5Hs2qALYKWxs=;
        b=SFMQ3KM36HmwXFALuuEhARJ+72KsCWPKLULLLUZjmohl1bYPWj6f+aj9313omcBxxh
         8y25z8oTlYZFtkI4GRsxOQm6wy/vqeW4WsZhCg1psKUs3giA2C6JKBAGyWKQ0ymR9KMe
         1YXobo5NIgvhKRf7GYMofDs0oyVNYOIAFS1mFfv+f/eK25aFVlv1qeZuBx/1vHQJ98Zz
         fLhG3DATXHq2U1bYzD80l0wzhxNV/nD2Cti355fsh+/crFu3O1JD9Jv0M1Yn1ML4uJ4C
         eZhsItAWowF+ev2D1aQJn7ObpEgq9kOPsrMzNuvup7h6qARV/wax9RMfahNApjUX1fbb
         krQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bTg0D8gCcPG/JWmmX96yNXeO3DHquJW5Hs2qALYKWxs=;
        b=punyaGGKeuAaBgD+C+eVIFNjKW3LxxkoKzFnbxW9DAMHnx8mW3B8lk+RuDPwNnYtW0
         +xNtRUrsOxPP1cw3NyMP/Bum7ztXZNSmex2xf59TV/frtjvd9S0qeR75YJZjhYD0uZhR
         ZvEX8ZnVF5pB4KPNfWgLhZX2Xae3adxaFIK3QvCumVjnaVRCPWvxbHk+uXJMz8kmdoMJ
         yjvQTAT1rotunCPZ0er0oLELcY47mswuKtQiwAEHEUyDdjx23W6t2gie9aPiGTDmoJ0H
         dc4s4yh06YIVxTHn+7f+RPvCPD2Yl4xyUZcc8xfP2gge910Hp7rDZlpoh+66QKbocc5R
         rqTg==
X-Gm-Message-State: APjAAAUG2g5bKu3JmxlTIBqC/oMwUBtQenA1X3zlFyC/hGBpK/k8aEZT
        zwadCybR9Sqnvfrut683yPomRg==
X-Google-Smtp-Source: APXvYqws6dx8eZj3ZAJKpzyyf1lqVM1zMx4B42Q9uEyJIfjcwovxR7fdXw1IKrlKLhJUsCozhr0QnQ==
X-Received: by 2002:a7b:c947:: with SMTP id i7mr28764649wml.77.1565616522204;
        Mon, 12 Aug 2019 06:28:42 -0700 (PDT)
Received: from fat-tyre.localnet ([2001:858:107:1:7139:36a7:c14f:e911])
        by smtp.gmail.com with ESMTPSA id e13sm10539700wmh.44.2019.08.12.06.28.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 06:28:41 -0700 (PDT)
From:   Philipp Reisner <philipp.reisner@linbit.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        'Christoph =?ISO-8859-1?Q?B=F6hmwalder=27?= 
        <christoph.boehmwalder@linbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] drbd: do not ignore signals in threads
Date:   Mon, 12 Aug 2019 15:28:40 +0200
Message-ID: <2789113.VEJ2NpTmzX@fat-tyre>
In-Reply-To: <1fcbb94c5f264c17af3394807438ad50@AcuMS.aculab.com>
References: <20190729083248.30362-1-christoph.boehmwalder@linbit.com> <1761552.9xIroHqhk7@fat-tyre> <1fcbb94c5f264c17af3394807438ad50@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi David,

[...]
> While our code is 'out of tree' (you really don't want it - and since
> it still uses force_sig() is fine) I suspect that the 'drdb' code
> (with Christoph's allow_signal() patch) now loops in kernel if a user
> sends it a signal.

I am not asking for that out of tree code. But you are welcome to learn
from the drbd code that is in the upstream kernel.
It does not loop if a root sends a signal, it receives it and ignores it.

> If the driver (eg drdb) is using (say) SIGINT to break a thread out of
> (say) a blocking kernel_accept() call then it can detect the unexpected
> signal (maybe double-checking with signal_pending()) but I don't think
> it can clear down the pending signal so that kernel_accept() blocks
> again.

You do that with flush_signals(current)

What we have do is, somewhere in the main loop:

  if (signal_pending(current)) {
			flush_signals(current);
			if (!terminate_condition()) {
				warn(connection, "Ignoring an unexpected signal\n");
				continue;
			}
			break;
		}
  }

=2D-=20
LINBIT | Keeping The Digital World Running

DRBD=AE and LINBIT=AE are registered trademarks of LINBIT, Austria.



