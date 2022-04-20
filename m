Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A63850922D
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 23:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351683AbiDTVmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 17:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240006AbiDTVmU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 17:42:20 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C4B38D9A;
        Wed, 20 Apr 2022 14:39:33 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id e128so2275440qkd.7;
        Wed, 20 Apr 2022 14:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=BYk2fcYYNkFE3mADh7FSh2IIx1qgteT/9cdQtTLkUN8=;
        b=YPLRLt99bmSdiQid0LB8hHE1BdYiasU+UdN8Oqnjk59AAnWaoVSV7+Z9w5KnY94pzI
         zWTu2bAVdU1lgv9fJ4U6NNVSQyZIAJB/FWDR5GbeqeOERsYSgZUWkzLs5OIT15GJSU6h
         Qjq1JiJDg23Zjl/s2AniLz/8JBhPmxAEy4e5KY+ixfN0wcvg2rjm+QUXTth9a9sp+qL7
         +Tz21onqt5QmUdpQ/neMyW+t79nL0R/yJ/zVjFnYnh4GAR7FEulcMREGYsuOsNnHXYfd
         9YtsQ/S7VLiNmxf2VzBNYsWMJ9AX+J4oNwviKI9k22AEVCkrDoaPv0wNTMDip92/cukE
         FCdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=BYk2fcYYNkFE3mADh7FSh2IIx1qgteT/9cdQtTLkUN8=;
        b=uyxWh+uX6GzcxmScYJ1x/lZ1psN5gDMAegC+/24cGQoDfLO/0cL4Gzq9++9Z+Wx82v
         AveRX6p9oXsxU15X8awx2LmSxErpIdQmshYfEVDOCxM4rBwjPHafrO5D12jj+gGYL0+O
         KOJVpWPLqCOPbJAopp33W8XXQ7nUudUT0HteIdBjpF9RMXC9risOOGLly6TpT5beYGEN
         mNkKrdmiSlT+zah0VnxcebS3A7zGzR8Yyb2QbASm4SO0Q+bgFduu8lrh+NGmpTKKQJMK
         cbQ5bmqM7fpiK/10yAho6zBrTxRZIH1P/ID4+tmjcy2KO+YJcWvfeDpE118oc9qaH9dm
         sGqQ==
X-Gm-Message-State: AOAM530QaafS0N9siBTDUL7mtbQi7dr3itQhBWL7O+PpIAkKdDpgLh5Y
        k7WXxvM5F09sXpPsUqrqr5E=
X-Google-Smtp-Source: ABdhPJxQSB75FRG4hG7gy2b15c7B48fChrQCCnG8R3sVky4altBLFcy79RTCtfzfbZuoYiE1yYWEBA==
X-Received: by 2002:a37:90e:0:b0:69e:a0f0:215c with SMTP id 14-20020a37090e000000b0069ea0f0215cmr9827583qkj.139.1650490772701;
        Wed, 20 Apr 2022 14:39:32 -0700 (PDT)
Received: from [120.7.1.38] (198-84-180-118.cpe.teksavvy.com. [198.84.180.118])
        by smtp.gmail.com with ESMTPSA id g21-20020ac85815000000b002e06e2623a7sm2247419qtg.0.2022.04.20.14.39.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Apr 2022 14:39:31 -0700 (PDT)
Subject: Re: [PATCH 1/2] ACPI: processor: Do not use C3 w/o ARB_DIS=1
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Ville Syrjala <ville.syrjala@linux.intel.com>
Cc:     ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Stable <stable@vger.kernel.org>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Richard Gong <richard.gong@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
References: <20220420134417.24546-1-ville.syrjala@linux.intel.com>
 <CAJZ5v0heJzWWio7m4-hO5j7q3fA-S6q6tXojJGsQ2rty-4hd2w@mail.gmail.com>
From:   Woody Suwalski <wsuwalski@gmail.com>
Message-ID: <ed380b4c-7869-12a7-b363-8469fab1c87a@gmail.com>
Date:   Wed, 20 Apr 2022 17:39:30 -0400
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:68.0) Gecko/20100101 Firefox/68.0
 SeaMonkey/2.53.11.1
MIME-Version: 1.0
In-Reply-To: <CAJZ5v0heJzWWio7m4-hO5j7q3fA-S6q6tXojJGsQ2rty-4hd2w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Rafael J. Wysocki wrote:
> On Wed, Apr 20, 2022 at 3:44 PM Ville Syrjala
> <ville.syrjala@linux.intel.com> wrote:
>> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
>>
>> commit d6b88ce2eb9d ("ACPI: processor idle: Allow playing dead in C3 state")
>> was supposedly just trying to enable C3 when the CPU is offlined,
>> but it also mistakenly enabled C3 usage without setting ARB_DIS=1
>> in normal idle scenarios.
>>
>> This results in a machine that won't boot past the point when it first
>> enters C3. Restore the correct behaviour (either demote to C1/C2, or
>> use C3 but also set ARB_DIS=1).
>>
>> I hit this on a Fujitsu Siemens Lifebook S6010 (P3) machine.
>>
>> Cc: stable@vger.kernel.org
>> Cc: Woody Suwalski <wsuwalski@gmail.com>
>> Cc: Mario Limonciello <mario.limonciello@amd.com>
>> Cc: Richard Gong <richard.gong@amd.com>
>> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> Fixes: d6b88ce2eb9d ("ACPI: processor idle: Allow playing dead in C3 state")
>> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
>> ---
>>   drivers/acpi/processor_idle.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
>> index 4556c86c3465..54f0a1915025 100644
>> --- a/drivers/acpi/processor_idle.c
>> +++ b/drivers/acpi/processor_idle.c
>> @@ -793,10 +793,10 @@ static int acpi_processor_setup_cstates(struct acpi_processor *pr)
>>
>>                  state->flags = 0;
>>                  if (cx->type == ACPI_STATE_C1 || cx->type == ACPI_STATE_C2 ||
>> -                   cx->type == ACPI_STATE_C3) {
>> +                   cx->type == ACPI_STATE_C3)
>>                          state->enter_dead = acpi_idle_play_dead;
>> +               if (cx->type == ACPI_STATE_C1 || cx->type == ACPI_STATE_C2)
>>                          drv->safe_state_index = count;
>> -               }
>>                  /*
>>                   * Halt-induced C1 is not good for ->enter_s2idle, because it
>>                   * re-enables interrupts on exit.  Moreover, C1 is generally not
>> --
> Good catch, but I would prefer doing the below which should be
> equivalent (modulo GMail-induced white space breakage):
>
> ---
>   drivers/acpi/processor_idle.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> Index: linux-pm/drivers/acpi/processor_idle.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/processor_idle.c
> +++ linux-pm/drivers/acpi/processor_idle.c
> @@ -795,7 +795,8 @@ static int acpi_processor_setup_cstates(
>           if (cx->type == ACPI_STATE_C1 || cx->type == ACPI_STATE_C2 ||
>               cx->type == ACPI_STATE_C3) {
>               state->enter_dead = acpi_idle_play_dead;
> -            drv->safe_state_index = count;
> +            if (cx->type != ACPI_STATE_C3)
> +                drv->safe_state_index = count;
>           }
>           /*
>            * Halt-induced C1 is not good for ->enter_s2idle, because it
I have tested both solutions from Ville and Rafael, and both work OK on T40.
Clearly, since Ville has duped the issue on a non-T40 machine, the 
processor_power_dmi_table[] solution is incorrect.

Rafael's solution seems simpler - so I also like it more :-)

Thanks, Woody


