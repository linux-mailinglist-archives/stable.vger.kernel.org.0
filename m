Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 734C73E31CF
	for <lists+stable@lfdr.de>; Sat,  7 Aug 2021 00:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbhHFWeI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 18:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbhHFWeI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 18:34:08 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05871C0613CF
        for <stable@vger.kernel.org>; Fri,  6 Aug 2021 15:33:51 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id az7so11584384qkb.5
        for <stable@vger.kernel.org>; Fri, 06 Aug 2021 15:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=BtBuE0qm1JVAvz5cI51mwR+Aw6HvlPFvZ5RuHOJzs04=;
        b=NVpHAsz2VjnsnY58JUU2Ow3jI4TFCFYJge5UekVZZwvhNQsuke37sYiieLqPAuLtx7
         04ovDDuyrKKUIXjA6Xxvlwiy99sIyvVhv/6I/XZYMw0d0jnRMgBBz6bhIZvHfCV0MiGw
         1p9fK243MN+dh3HB+UadWMAhOn3eVjqj3+Ecoo1wjJBtwmYzzLnwfXogokDUM0nmSIXv
         rId0Gk/r8EDBjpfZIjy2T8Nr1kaYx2XqHbxIlGTIrqiKQM53oIJS/gnmUYYlrI14pd41
         hHG1nbuIT/04qVX0hnP7isyUG1PUMqWuxq14UBhIzxZk3jPamXJIGqHd8o87Vt6dQGt0
         W4Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:cc:from:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=BtBuE0qm1JVAvz5cI51mwR+Aw6HvlPFvZ5RuHOJzs04=;
        b=DwhDLCLeoVJweYCL8YMvZYPXIwSLIK/SxFbkLcOE8tqYyLd6czUUZaGHE+tUoieIoM
         dNmEekzTTRetCGB1jdYV19UPZsBaFGDbAPVRq/hntFl9T30Vf51NTw3QBeDpOx8cOJTr
         oEci3D9HVIz2/MJ8wcCiLcYmnlsDeUU7UWmuBylWZk1M9fgXPi4w20Xr1aD8++kIp2Ez
         hDpfOIeQMJ0jUItwXuaAM6XxzBqsEdUqnVzfftTacKXXTH8X+AicvgIuDXtuf+gL+Faw
         hZJKpkTXx8OtG9ML5vW0tjBWS9SBXCgK9ftRR8pOSdjTRZ9zHTZIbRzMvQ0xFZIXw0pj
         2pfA==
X-Gm-Message-State: AOAM530PrnERVvjOyORgd83T0aFL/WdA5wJ49BzyioIh6zB2ISkdky4h
        GnIMPVw1M7zu66jOlToypds=
X-Google-Smtp-Source: ABdhPJz8UiaoyXh4bkbkKrONGmOjlkdW2IHiv0cIPGx0+gDBiU1uLInDf2TB0pK5p4qZCayXOKXabQ==
X-Received: by 2002:a37:ace:: with SMTP id 197mr3679741qkk.448.1628289230258;
        Fri, 06 Aug 2021 15:33:50 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h140sm2789261qke.112.2021.08.06.15.33.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 15:33:49 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     regressions@lists.linux.dev
Cc:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frank Wunderlich <frank-w@public-files.de>,
        Peter Hess <peter.hess@ph-home.de>,
        Mark Brown <broonie@kernel.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: regression [fixed]: SPI interface on systems with Mediatek CPU broken
Message-ID: <d865ef60-034e-32ab-3978-601b97d8904e@roeck-us.net>
Date:   Fri, 6 Aug 2021 15:33:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ submitted for reference. The problem has now been fixed in the upstream kernel ]

Affected upstream kernel releases: v5.14-rc3, v5.14-rc4
Various stable releases with the problematic commit are also affected.

The SPI interface on systems with various Mediatek CPUs is not operational.
The problem affects all Chromebooks with Mediatek CPU since those Chromebooks
use the SPI interface to connect to the Embedded Controller.

Bisect suggests that commit 3a70dd2d050 ("spi: mediatek: fix fifo rx mode")
introduced the problem. The problem was fixed with upstream commit 0d5c3954b35e
("spi: mediatek: Fix fifo transfer").

Detailed problem description from commit 0d5c3954b35e:

     Commit 3a70dd2d0503 ("spi: mediatek: fix fifo rx mode") claims that
     fifo RX mode was never handled, and adds the presumably missing code
     to the FIFO transfer function. However, the claim that receive data
     was not handled is incorrect. It was handled as part of interrupt
     handling after the transfer was complete. The code added with the above
     mentioned commit reads data from the receive FIFO before the transfer
     is started, which is wrong. This results in an actual transfer error
     on a Hayato Chromebook.

     Remove the code trying to handle receive data before the transfer is
     started to fix the problem.

Guenter
