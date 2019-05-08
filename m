Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D72091810B
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 22:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729488AbfEHU0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 16:26:45 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39111 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729003AbfEHU0p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 May 2019 16:26:45 -0400
Received: by mail-pg1-f195.google.com with SMTP id w22so9342471pgi.6
        for <stable@vger.kernel.org>; Wed, 08 May 2019 13:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=OoSAyLqOzoTY4imTMlt5PXtdUH44ZwugWLFtgR1oxSE=;
        b=tV5HH5lWOzHtckicgsfc51J6eNwMvV2tW+XHuF6CYyJUdxBtE1UJVmLFLeV5joiFWN
         uxjlFtB+LxasFatjjPafAohY9evgEv+8ADu5Uyi9FHAhNPbVJmvq0wYRqdBv/7rusYGU
         0zEUlRzHjo74veCDdg+/RHOBm/cyJ0UQDX3qU/HBqDt50im2NsaSv7bpZouSpC9JoC3B
         acSRkq46X8/LmyKUnDuRtknHutDaPJFhnCs8ENjgWsQGhm2b0/gqysMsJh3rkeKjNQ1f
         sCGzZg8dnfKChXGhp1tPblzEPbWSAKJvYgM+LSIdoYuf/9eYaOoByQ8bGQ2SiT7pwU6x
         qDTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=OoSAyLqOzoTY4imTMlt5PXtdUH44ZwugWLFtgR1oxSE=;
        b=Dc1feiS/bZCril03pu+cJgimzDBulLe0vz8GwwDFAF2ZT7Y2v26mevEAAA7Cnku90W
         PSlNlnvT50mJppO5iWYTDS/r1R7kV2qQTx422rh8Dn9BRRNb8tFnKhsh2Gt3UrSERscc
         jYpdxNcoSH8EAu5IsDN/+HmLPp+6b4dXLItTuEd2R4uZf7j+GqfHgncdTP6UEHh8ewT3
         uvP20oViIheU16w62NR5QrHBgb2CYBZTQfMD5sWe6z7Cob+Q41jXSsyQNh+boIW7n0/A
         emi9d3BTmQjxSCbenZabIhtHbEsRJWJQ5d7CSUQcb4VIP7swF4PXSWFKcdb71jn3wRkF
         igHQ==
X-Gm-Message-State: APjAAAWzFNVmvAxBXv7KXECZv9AxXD2U3JV5Ae68H6Pevo/I2yg9NOP0
        7Mah9/seNPYBK8xkVrvhP2jYuQqG
X-Google-Smtp-Source: APXvYqwMoiauZe5i8ofLrMADrXvHo3BJVxcQ/isefeiLoACkGMIXY53jBARJIbq4SNGDqLdtRN4n2Q==
X-Received: by 2002:a63:e602:: with SMTP id g2mr168941pgh.172.1557347204831;
        Wed, 08 May 2019 13:26:44 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 18sm141094pfp.18.2019.05.08.13.26.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 13:26:43 -0700 (PDT)
Date:   Wed, 8 May 2019 13:26:42 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org
Subject: Build failure in v4.4.y.queue (ppc:allmodconfig)
Message-ID: <20190508202642.GA28212@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I see multiple instances of:

arch/powerpc/kernel/exceptions-64s.S:839: Error:
	attempt to move .org backwards

in v4.4.y.queue (v4.4.179-143-gc4db218e9451).

This is due to commit 9b2d4e06d7f1 ("powerpc/64s: Add support for a store
forwarding barrier at kernel entry/exit"), which is part of a large patch
series and can not easily be reverted.

Guess I'll stop doing ppc:allmodconfig builds in v4.4.y ?

Thanks,
Guenter
