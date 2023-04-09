Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30FEC6DBFD6
	for <lists+stable@lfdr.de>; Sun,  9 Apr 2023 14:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjDIMbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Apr 2023 08:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjDIMbG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Apr 2023 08:31:06 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FBB3A9B;
        Sun,  9 Apr 2023 05:31:02 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id 20so4313026plk.10;
        Sun, 09 Apr 2023 05:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681043462;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/sjCjsfv26tkwL33cYuaCIiIygw6W5wLP/nI9o69MBE=;
        b=knP/zr0lg3cA56UTp147xq5KaWNFpUT6fj2NAYVrCspJgHf4+T0aw8tQvplFo3+jmS
         LCh467KwtrloXokQo8xWWqOPNQ6JOlg0A34GEvR3dmNAQ5jduLziBGAIG9CudtsJxtrV
         7Zm9Ku+FslXcMzQXg0nL0++Wpx+UTYz90ybiY7f+oRQ62Gs9C3FxxCCNA33pzI6oJi4C
         pjFiZLfcPa0Ay3qxbdwc9K//Y096/OoOvuNqVONyK8anac2vGYTs2bLtE1nykBBHqS6C
         lLImrVfpaBLIwYI59opSsLjCDKL8nUc13223uPWh+aMbkpJDjf8IH+heZ9a9YXGJGnig
         VAIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681043462;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/sjCjsfv26tkwL33cYuaCIiIygw6W5wLP/nI9o69MBE=;
        b=Od6mE6m6m4MYEMfN+uWugL9KaIPeyU4zyxS/hRwEuTr1K6s80YTfHkGT+euqEn5qap
         /ZPmxkt+slmz/icZkikcG9FKW6q9dC750NOwy8zUX9A9woIbp7lvPI5A4eb7SYT4AbSM
         rFlmqvaf44tsWh5sUOttR0eOviJ4Se7kr9RYPB4DoFawXxbYEAoqzl7MHmKMa39hd3qo
         3TtUAjet02UmWdE0mUkpDz3Otkqtu38qNs16LJxwQPiMjVIno/zPWrV6oNRt9sPYVVzL
         KO7ZwuHzSnN42JRry42+0h9FFcexynxcVomH3bpK9Hz/3/grfqOBEzP373VjORjJCNi3
         GXng==
X-Gm-Message-State: AAQBX9cETVLP+NgTjZmyH2sZcjXB2aGRgrMmf1W/DKQHq01wEQpdM5U6
        b5A7vsBaE0Qof3X/DIG20IyqwW8s7cQ=
X-Google-Smtp-Source: AKy350Zi0/jHiXU7qIaSCN3O1DJL5eFsyUZRuJgq7cd2DopUoKCuA1EtplmHA8nvTTwnIYiRy6P0Sw==
X-Received: by 2002:a17:903:7cd:b0:19e:674a:1fb9 with SMTP id ko13-20020a17090307cd00b0019e674a1fb9mr8024227plb.69.1681043461624;
        Sun, 09 Apr 2023 05:31:01 -0700 (PDT)
Received: from [192.168.43.80] (subs32-116-206-28-11.three.co.id. [116.206.28.11])
        by smtp.gmail.com with ESMTPSA id s31-20020a63ff5f000000b005182bfef363sm2034215pgk.34.2023.04.09.05.30.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Apr 2023 05:31:00 -0700 (PDT)
Message-ID: <b05d80ab-fd72-1346-f5d9-b80ae9b5cd1a@gmail.com>
Date:   Sun, 9 Apr 2023 19:30:53 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v2] ring-buffer: Prevent inconsistent operation on
 cpu_buffer->resize_disabled
To:     Tze-nan Wu <Tze-nan.Wu@mediatek.com>, rostedt@goodmis.org,
        mhiramat@kernel.org
Cc:     bobule.chang@mediatek.com, wsd_upstream@mediatek.com,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230408052226.25268-1-Tze-nan.Wu@mediatek.com>
 <20230409024616.31099-1-Tze-nan.Wu@mediatek.com>
Content-Language: en-US
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20230409024616.31099-1-Tze-nan.Wu@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/9/23 09:46, Tze-nan Wu wrote:
> This issue can be reproduced by "echo 0 > trace" and hotplug cpu at the
> same time. After reproducing success, we can find out buffer_size_kb
> will not be functional anymore.
> 

Do you mean disabling tracing while hotplugging CPU? Or disabling both
tracing and hotplug CPU?

> This patch uses cpus_read_lock() to prevent cpu_online_mask being changed
> between two different "for_each_online_buffer_cpu".
> 

"Use cpu_read_lock() to prevent ..."

> Changes in v2:
>   Use cpus_read_lock() instead of copying cpu_online_mask at the entry of
>   function
> 

To resolve kernel test robot warnings ([1] and [2])? Or have they been fixed?

[1]: https://lore.kernel.org/stable/202304081615.eiaqpbV8-lkp@intel.com/
[2]: https://lore.kernel.org/stable/202304082051.Dp50upfS-lkp@intel.com/

Thanks.

-- 
An old man doll... just what I always wanted! - Clara

