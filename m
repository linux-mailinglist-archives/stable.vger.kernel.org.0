Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957BC268298
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 04:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgINC2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Sep 2020 22:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgINC2k (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Sep 2020 22:28:40 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F1FC06174A;
        Sun, 13 Sep 2020 19:28:40 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id gf14so4549865pjb.5;
        Sun, 13 Sep 2020 19:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=tBnOPAiQAmuM/zw7OunepnMvNhW7KRIsJ8xiVhAMSfY=;
        b=Gie2ZEAyK8kU612WNHDufwN5+26XZWkfn8BPHvSMCJYgtuOJLzL4MZZT5+QnCNLiyZ
         mPVjLzY+99864U40wBb7tGfwiFDQtea35YXWYVvFGrKWUebubAt4YyYgxdOFaPr4DXwO
         QSxExkHuAw+Y/f23CeXVqmfYXI8+8o2KBaEhAjlaH0kRow6SiL0bLe95d1GUxGRlWLa6
         15MNR/xoz+d6ptPGcmOlJi+f2Zl7mtIILDP8DQYSjKW2cWJJ7p5TbCkVT0gKMm7UqiKZ
         W5Ax7RqOAqrUGw80Z0J9eDWYNh0OX6sa3AF4zhp25ToMlafA+wkrguAopIauOLknYWik
         TEBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=tBnOPAiQAmuM/zw7OunepnMvNhW7KRIsJ8xiVhAMSfY=;
        b=E7uciPfg1YUM7fZRj7/Opd7XrKzeOdRwXzYqi3GM84rkdn3wKrsvWAzHyk6MDixjz4
         gdN4xYhaM5On7TnoZyVWdrAYeQcNGlD0Rz8ZJnY0R2U7wx1SM/UmfS6ZHx7oU5PFlPlf
         fteFm6V2kgdgyg11/fDOLm3wgeWabWxH/vB8ohdAc+Se3SV58sgnHrjQPPvxSHx6HU/c
         LgxNveP8FSflzFj4S/1uxaoQmJIYQDgawZc0LdjUApJgXcmk2ePPaBw+0XsIO+9xURhC
         4eWBdL76lkd8mZqY5/Ug3h74pUXrv3gJEH/0VDk1u32PqRdU5pm1/pu+aApqGgxVroCS
         Oa+Q==
X-Gm-Message-State: AOAM531Wjo/A20NC0sBZ0rjABWmGRBqROe/GFB9C0I6j09fWEkHgdnH/
        M9itMSC2Y2m9nxnNzu4rBoxyI3zw7DM=
X-Google-Smtp-Source: ABdhPJwWpH0s9rwvXAYAPU7hBSiPDm5noXNGFxGop+M8aV0zknJAhjVngYlbq5Y81skHhxIyeyZYSw==
X-Received: by 2002:a17:90a:71c7:: with SMTP id m7mr12651457pjs.190.1600050519548;
        Sun, 13 Sep 2020 19:28:39 -0700 (PDT)
Received: from localhost ([203.185.249.227])
        by smtp.gmail.com with ESMTPSA id z11sm8724267pfc.181.2020.09.13.19.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2020 19:28:39 -0700 (PDT)
Date:   Mon, 14 Sep 2020 12:28:34 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH] spi: fsl-espi: Only process interrupts for expected
 events
To:     "broonie@kernel.org" <broonie@kernel.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20200904002812.7300-1-chris.packham@alliedtelesis.co.nz>
        <ecedc71d-100a-7d7a-ff7f-ef1a3086dd74@alliedtelesis.co.nz>
In-Reply-To: <ecedc71d-100a-7d7a-ff7f-ef1a3086dd74@alliedtelesis.co.nz>
MIME-Version: 1.0
Message-Id: <1600050281.5iiy8pkb7z.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Excerpts from Chris Packham's message of September 14, 2020 8:03 am:
> Hi All,
>=20
> On 4/09/20 12:28 pm, Chris Packham wrote:
>> The SPIE register contains counts for the TX FIFO so any time the irq
>> handler was invoked we would attempt to process the RX/TX fifos. Use the
>> SPIM value to mask the events so that we only process interrupts that
>> were expected.
>>
>> This was a latent issue exposed by commit 3282a3da25bd ("powerpc/64:
>> Implement soft interrupt replay in C").
>>
>> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
>> Cc: stable@vger.kernel.org
>> ---
> ping?

I don't know the code/hardware but thanks for tracking this down.

Was there anything more to be done with Jocke's observations, or would=20
that be a follow-up patch if anything?

If this patch fixes your problem it should probably go in, unless there=20
are any objections.

Thanks,
Nick

>>
>> Notes:
>>      I've tested this on a T2080RDB and a custom board using the T2081 S=
oC. With
>>      this change I don't see any spurious instances of the "Transfer don=
e but
>>      SPIE_DON isn't set!" or "Transfer done but rx/tx fifo's aren't empt=
y!" messages
>>      and the updates to spi flash are successful.
>>     =20
>>      I think this should go into the stable trees that contain 3282a3da2=
5bd but I
>>      haven't added a Fixes: tag because I think 3282a3da25bd exposed the=
 issue as
>>      opposed to causing it.
>>
>>   drivers/spi/spi-fsl-espi.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/spi/spi-fsl-espi.c b/drivers/spi/spi-fsl-espi.c
>> index 7e7c92cafdbb..cb120b68c0e2 100644
>> --- a/drivers/spi/spi-fsl-espi.c
>> +++ b/drivers/spi/spi-fsl-espi.c
>> @@ -574,13 +574,14 @@ static void fsl_espi_cpu_irq(struct fsl_espi *espi=
, u32 events)
>>   static irqreturn_t fsl_espi_irq(s32 irq, void *context_data)
>>   {
>>   	struct fsl_espi *espi =3D context_data;
>> -	u32 events;
>> +	u32 events, mask;
>>  =20
>>   	spin_lock(&espi->lock);
>>  =20
>>   	/* Get interrupt events(tx/rx) */
>>   	events =3D fsl_espi_read_reg(espi, ESPI_SPIE);
>> -	if (!events) {
>> +	mask =3D fsl_espi_read_reg(espi, ESPI_SPIM);
>> +	if (!(events & mask)) {
>>   		spin_unlock(&espi->lock);
>>   		return IRQ_NONE;
>>   	}
