Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F97C14AA0C
	for <lists+stable@lfdr.de>; Mon, 27 Jan 2020 19:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgA0Ss0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 13:48:26 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:44270 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbgA0Ss0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jan 2020 13:48:26 -0500
Received: by mail-ot1-f67.google.com with SMTP id h9so9411750otj.11
        for <stable@vger.kernel.org>; Mon, 27 Jan 2020 10:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zw+XZaa7gsUARBGtJkOR+0K2wPyg8TohxAXhDQGURpc=;
        b=DxhuDK2AbqHMU9yVMFAZ7NqQXRXIIMwO1AgBZ7eaYuLRku77A1qgEOxEpHK3Gd7Z6A
         VugoQRFhLt/2slyfuaH65zJy0g4AegqT2Ja7PrwfYGgQ+Ggzv1zpwfCJg0lwgdluMBZA
         4bXh5/pnRzn8+rgwNJAMY7kFUp/yIt3Zu6LJLLdaq1lTH+dKM5cRymOIolHl9bafWxNn
         kHu1eFv/q0GvDY1di17cMHNSNjyvF1/akb/yLLjH+UkBtbntj5YEp0zYa06OeHqyas5u
         f6css1Ix9JXmXySXn75uTOuGr/9iUjoMogs0t5mB7WuQLxB/P4KmdVd3NleFhYJ7gIyA
         LJRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zw+XZaa7gsUARBGtJkOR+0K2wPyg8TohxAXhDQGURpc=;
        b=bWCogHzN/8WPbrMZVbBz3NkiE8UH6oqsOrzXoXsdtCIFaBLWt/1jgCKoQl2gPu4lv8
         l9D8XlQfjiR0TPBBr5wYQ6fr/GbAlp7pq1cgOaTWF8wKIckihqlAzAsfEmts9O9zk6M/
         lSUhbYd1gWMGPeNCtjIHhTrYjX1uKPRdfKl2MttYElPXOcyR2kMEK739mRzneM7EUhgW
         +T6bieHYBzfpQ1qtosYN9v3BNX5gG0uq7T+n3Rzz/G/08lPBWdHaVxA/8CDabeMuvb1V
         3cpFjgAVXPweNip0tsV+iUDlXj3VPhoysfFeYBpipoAhQ3FID+FdsWGRqx35NU/1HMTm
         77Yw==
X-Gm-Message-State: APjAAAWZoZ9Cp4HpBIQ/vrtspQVrbDtY0dksW0jl/ahjfFBMM/7SGVNG
        7AiIwiIB3mfqP8qmqD3BWfQePCCrp8430KMvJHau4Q==
X-Google-Smtp-Source: APXvYqz98obeG+UIMNKdbaDJLwPj2RseT8dj+H7fy5qimmJNzzbcezjsN0a7jhxxpkpL5CTCcRzVOBvFgWSEr6S7DwI=
X-Received: by 2002:a9d:6304:: with SMTP id q4mr13597186otk.332.1580150904289;
 Mon, 27 Jan 2020 10:48:24 -0800 (PST)
MIME-Version: 1.0
References: <20200122222645.38805-1-john.stultz@linaro.org>
 <20200122222645.38805-2-john.stultz@linaro.org> <87tv4m4ov2.fsf@kernel.org>
 <CALAqxLUeBf2Jx2tLW1yzJk6JHM0RP9cJbTt7m19Qdz-rWMw2mQ@mail.gmail.com>
 <87iml147sd.fsf@kernel.org> <CALAqxLVBv_1AJLZAiB3yLuf-MY2p4Nt5p3xTsbR0qkmyNV5U9g@mail.gmail.com>
 <877e1fu7d8.fsf@kernel.org>
In-Reply-To: <877e1fu7d8.fsf@kernel.org>
From:   John Stultz <john.stultz@linaro.org>
Date:   Mon, 27 Jan 2020 10:48:12 -0800
Message-ID: <CALAqxLWw5ydkHGoZZk7RKZj_0HXeJ_oV-Q0J_iN8dDjX9DTVOw@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] usb: dwc3: gadget: Check for IOC/LST bit in both
 event->status and TRB->ctrl fields
To:     Felipe Balbi <balbi@kernel.org>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>,
        Yang Fei <fei.yang@intel.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Tejas Joglekar <tejas.joglekar@synopsys.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Jack Pham <jackp@codeaurora.org>, Todd Kjos <tkjos@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 25, 2020 at 3:01 AM Felipe Balbi <balbi@kernel.org> wrote:
>
>
> Hi,
>
> John Stultz <john.stultz@linaro.org> writes:
> >> > On Wed, Jan 22, 2020 at 11:23 PM Felipe Balbi <balbi@kernel.org> wrote:
> >> >> > From: Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>
> >> >> >
> >> >> > The present code in dwc3_gadget_ep_reclaim_completed_trb() will check
> >> >> > for IOC/LST bit in the event->status and returns if IOC/LST bit is
> >> >> > set. This logic doesn't work if multiple TRBs are queued per
> >> >> > request and the IOC/LST bit is set on the last TRB of that request.
> >> >> > Consider an example where a queued request has multiple queued TRBs
> >> >> > and IOC/LST bit is set only for the last TRB. In this case, the Core
> >> >> > generates XferComplete/XferInProgress events only for the last TRB
> >> >> > (since IOC/LST are set only for the last TRB). As per the logic in
> >> >> > dwc3_gadget_ep_reclaim_completed_trb() event->status is checked for
> >> >> > IOC/LST bit and returns on the first TRB. This makes the remaining
> >> >> > TRBs left unhandled.
> >> >> > To aviod this, changed the code to check for IOC/LST bits in both
> >> >>      avoid
> >> >>
> >> >> > event->status & TRB->ctrl. This patch does the same.
> >> >>
> >> >> We don't need to check both. It's very likely that checking the TRB is
> >> >> enough.
> >> >
> >> > Sorry, just to clarify, are you suggesting instead of:
> >> > -       if (event->status & DEPEVT_STATUS_IOC)
> >> > +       if ((event->status & DEPEVT_STATUS_IOC) &&
> >> > +           (trb->ctrl & DWC3_TRB_CTRL_IOC))
> >> >
> >> >
> >> > We do something like:
> >> > -       if (event->status & DEPEVT_STATUS_IOC)
> >> > +       if (trb->ctrl & DWC3_TRB_CTRL_IOC)
> >> > +               return 1;
> >> > +
> >> > +       if (trb->ctrl & DWC3_TRB_CTRL_LST)
> >> >                 return 1;
> >> >
> >> > ?
> >>
> >> that's correct. In hindsight, I have no idea why I used the
> >> event->status here since all other checks are done against the TRB
> >> only.
> >>
> >> >> > At a practical level, this patch resolves USB transfer stalls seen
> >> >> > with adb on dwc3 based HiKey960 after functionfs gadget added
> >> >> > scatter-gather support around v4.20.
> >> >>
> >> >> Right, I remember asking for tracepoint data showing this problem
> >> >> happening. It's the best way to figure out what's really going on.
> >> >>
> >> >> Before we accept these two patches, could you collect dwc3 tracepoint
> >> >> data and share here?
> >> >
> >> > Sure. Attached is trace logs and regdumps for hikey960.
> >>
> >> Thanks
> >>
> >> > The one gotcha with the logs is that in the working case (with this
> >> > patch applied), I booted with the usb-c cable disconnected (as
> >> > suggested in the dwc3.rst doc), enabled tracing and plugged in the
> >> > device, then ran adb logcat a few times to validate no stalls.
> >> >
> >> > In the failure case (without this patch), I booted with the usb-c
> >> > cable disconnected, enabled tracing and then when I plugged in the
> >> > device, it never was detected by adb (it seems perhaps the problem had
> >> > already struck?).
> >>
> >> You never got a Reset Interrupt, so something else is going on. I
> >> suggest putting a sniffer and first making sure the host *does* drive
> >> reset signalling. Second step would be to look at your phy
> >> configuration. Is it going in suspend for any reason? Might want to try
> >> our snps,dis_u3_susphy_quirk and snps,dis_u2_susphy_quirk flags.
> >>
> >> > So I generated the failure2 log by booting with USB-C plugged in,
> >> > enabling tracing, and running adb logcat on the host to observe the
> >> > stall.
> >>
> >> Thank you. Here's a quick summary of what's in failure2:
> >>
> >> There is a series of 24-byte transfers on ep1out and that's the one
> >> which shows a problem. We can clearly see that adb is issuing one
> >> transfer at a time, only enqueueing transfer n+1 when transfer n is
> >> completed and given back, so we see a series of similar blocks:
> >>
> >> - dwc3_alloc_request
> >> - dwc3_ep_queue
> >> - dwc3_prepare_trb
> >> - dwc3_prepare_trb (for the chained bit)
> >> - dwc3_gadget_ep_cmd (update transfer)
> >> - dwc3_event (transfer in progress)
> >> - dwc3_complete_trb
> >> - dwc3_complete_trb (for the chained bit)
> >> - dwc3_gadget_giveback
> >> - dwc3_free_request
> >>
> >> So this works for several iterations. Note, however, that the TRB
> >> addresses don't really make sense. DWC3 allocates a contiguous block of
> >> memory to server as TRB pool, but we see non-consecutive addresses on
> >> these TRBs. I'm assuming there's an IOMMU in your system.
> >>
> >> Anyway, the failing point is here:
> >>
> >> >          adbd-461   [002] d..1    49.855992: dwc3_alloc_request: ep1out: req 000000004e6eaaba length 0/0 zsI ==> 0
> >> >          adbd-461   [002] d..2    49.855994: dwc3_ep_queue: ep1out: req 000000004e6eaaba length 0/24 zsI ==> -115
> >> >          adbd-461   [002] d..2    49.855996: dwc3_prepare_trb: ep1out: trb 00000000bae39b48 buf 000000009eb0b100 size 24 ctrl 0000001d (HlCS:sc:normal)
> >> >          adbd-461   [002] d..2    49.855997: dwc3_prepare_trb: ep1out: trb 000000009093a074 buf 0000000217da8000 size 488 ctrl 00000819 (HlcS:sC:normal)
> >> >          adbd-461   [002] d..2    49.856003: dwc3_gadget_ep_cmd: ep1out: cmd 'Update Transfer' [20007] params 00000000 00000000 00000000 --> status: Successful
> >> >   irq/65-dwc3-498   [000] d..1    53.902752: dwc3_event: event (00006084): ep1out: Transfer In Progress [0] (SIm)
> >> >   irq/65-dwc3-498   [000] d..1    53.902763: dwc3_complete_trb: ep1out: trb 00000000bae39b48 buf 000000009eb0b100 size 0 ctrl 0000001c (hlCS:sc:normal)
> >> >   irq/65-dwc3-498   [000] d..1    53.902769: dwc3_complete_trb: ep1out: trb 000000009093a074 buf 0000000217da8000 size 488 ctrl 00000819 (HlcS:sC:normal)
> >> >   irq/65-dwc3-498   [000] d..1    53.902781: dwc3_gadget_giveback: ep1out: req 000000004e6eaaba length 24/24 zsI ==> 0
> >> > kworker/u16:0-7     [000] ....    53.903020: dwc3_free_request: ep1out: req 000000004e6eaaba length 24/24 zsI ==> 0
> >> >          adbd-461   [002] d..1    53.903273: dwc3_alloc_request: ep1out: req 00000000c769beab length 0/0 zsI ==> 0
> >> >          adbd-461   [002] d..2    53.903285: dwc3_ep_queue: ep1out: req 00000000c769beab length 0/24 zsI ==> -115
> >> >          adbd-461   [002] d..2    53.903292: dwc3_prepare_trb: ep1out: trb 00000000f0ffa827 buf 000000009eb11e80 size 24 ctrl 0000001d (HlCS:sc:normal)
> >> >          adbd-461   [002] d..2    53.903296: dwc3_prepare_trb: ep1out: trb 00000000d6a9892a buf 0000000217da8000 size 488 ctrl 00000819 (HlcS:sC:normal)
> >> >          adbd-461   [002] d..2    53.903315: dwc3_gadget_ep_cmd: ep1out: cmd 'Update Transfer' [20007] params 00000000 00000000 00000000 --> status: Successful
> >>
> >> Note that this transfer, after started, took 4 seconds to complete,
> >> while all others completed within a few ms. There's no real reason for
> >> this visible from dwc3 driver itself. What follows, is a transfer that
> >> never completed.
> >>
> >> The only thing I can come up with, is that we starve the TRB ring, by
> >> continuously reclaiming a single TRB. We have 255 usable TRBs, so after
> >> a few iterations, we would see a stall due to starved TRB ring.
> >>
> >> There is a way to verify this by tracking trb_enqueue and trb_dequeue,
> >> if you're willing to do that, that'll help us prove that this is really
> >> the problem and, since current tracepoints doen't really show that
> >> information, it may be a good idea to add this information to
> >> dwc3_log_trb tracepoint class. Something like below should be enough,
> >> could you re-run the test of failure2 with this patch applied?
> >
> >
> > Ok. Attached is the trace logs using the new tracepoints with and
> > without the patch. In both cases, I started with the usb-c cable
> > plugged in, started tracing and ran "adb logcat -d" a few times.
> >
> > Also, in the -with-fix case, I'm using the patch modified as we
> > discussed yesterday (which still avoids the issue). If this log
> > confirms your suspicions I'll go ahead and resubmit the new patch.
>
> So the problem is caused with ep1in, not ep1out as I originally
> though. Here's snippet with the fix:
>
>             adbd-2020  [005] d..2   696.765411: dwc3_ep_queue: ep1in: req 0000000090c1f3b7 length 0/8197 zsI ==> -115
>             adbd-2020  [005] d..2   696.765414: dwc3_prepare_trb: ep1in: trb 00000000c0b7b1ee (E97:D96) buf 00000000aac5d000 size 4096 ctrl 00000015 (HlCs:sc:normal)
>             adbd-2020  [005] d..2   696.765415: dwc3_prepare_trb: ep1in: trb 00000000cd8ddc31 (E98:D96) buf 00000000adf18000 size 4101 ctrl 00000811 (Hlcs:sC:normal)
>             adbd-2020  [005] d..2   696.765419: dwc3_gadget_ep_cmd: ep1in: cmd 'Update Transfer' [30007] params 00000000 00000000 00000000 --> status: Successful
>      irq/65-dwc3-2021  [000] d..1   696.765640: dwc3_event: event (00004086): ep1in: Transfer In Progress [0] (sIm)
>      irq/65-dwc3-2021  [000] d..1   696.765642: dwc3_complete_trb: ep1in: trb 00000000c0b7b1ee (E98:D97) buf 00000000aac5d000 size 0 ctrl 00000014 (hlCs:sc:normal)
>      irq/65-dwc3-2021  [000] d..1   696.765644: dwc3_complete_trb: ep1in: trb 00000000cd8ddc31 (E98:D98) buf 00000000adf18000 size 0 ctrl 00000810 (hlcs:sC:normal)
>      irq/65-dwc3-2021  [000] d..1   696.765647: dwc3_gadget_giveback: ep1in: req 0000000090c1f3b7 length 8197/8197 zsI ==> 0
>    kworker/u16:0-7     [003] ....   696.765667: dwc3_free_request: ep1in: req 0000000090c1f3b7 length 8197/8197 zsI ==> 0
>
> And without the fix:
>
>             adbd-469   [005] d..1    40.118540: dwc3_alloc_request: ep1in: req 000000000dca92a3 length 0/0 zsI ==> 0
>             adbd-469   [005] d..2    40.118541: dwc3_ep_queue: ep1in: req 000000000dca92a3 length 0/5424 zsI ==> -115
>             adbd-469   [005] d..2    40.118543: dwc3_prepare_trb: ep1in: trb 0000000020352887 (E77:D76) buf 0000000057db5000 size 4096 ctrl 00000015 (HlCs:sc:normal)
>             adbd-469   [005] d..2    40.118543: dwc3_prepare_trb: ep1in: trb 00000000227d614e (E78:D76) buf 0000000057db4000 size 1328 ctrl 00000811 (Hlcs:sC:normal)
>             adbd-469   [005] d..2    40.118547: dwc3_gadget_ep_cmd: ep1in: cmd 'Update Transfer' [30007] params 00000000 00000000 00000000 --> status: Successful
>      irq/65-dwc3-473   [000] d..1    40.118720: dwc3_event: event (00004086): ep1in: Transfer In Progress [0] (sIm)
>      irq/65-dwc3-473   [000] d..1    40.118721: dwc3_complete_trb: ep1in: trb 0000000020352887 (E78:D77) buf 0000000057db5000 size 0 ctrl 00000014 (hlCs:sc:normal)
>      irq/65-dwc3-473   [000] d..1    40.118730: dwc3_gadget_ep_cmd: ep1in: cmd 'Update Transfer' [30007] params 00000000 00000000 00000000 --> status: Successful
>
> Note that we completed a single TRB in the failure case. The odd thing
> is why this doesn't happen with OUT direction? (/me goes look at the
> code).
>
> Okay, here's the answer: With OUT direction, DWC3, itself, is adding an
> extra chained TRB because OUT transfers must be aligned to
> wMaxPacketSize. Because of that we set needs_extra_trb flag which causes
> this flow:
>
> XferInProgress
>   dwc3_gadget_ep_cleanup_completed_request
>     dwc3_gadget_ep_reclaim_trb_sg
>       for_each_sg {
>         dwc3_gadget_ep_reclaim_completed_trb
>           if (IOC)
>             break;
>       }
>       if (needs_extra_trb)
>         dwc3_gadget_ep_reclaim_trb_linear
>           dwc3_gadget_ep_reclaim_completed_trb
>
> In summary, OUT directions work solely out of luck :-) If gadget
> function enqueues an unaligned request with sglist already in it, it
> should fail the same way, since we will append another TRB to something
> that already uses more than one TRB.
>
> We should probably add some of this explanation to commit log as well
> and, BTW, tracepoints actually had the data to show where the problem
> was, arguably printing out enqueue and dequeue points made it easier to
> see the issue.
>
> I'm now convinced of what the problem really is, please resend the
> modified patch so we can apply and backport it.

Sure thing! Though I'm not as adept at staring at the matrix/tracelogs
as you, so I'll do my best to add a comment to the commit log to the
effect of the above, but it may not be accurate so feel free to reword
it yourself to correct it after I send it out. :)

thanks so much again for taking a look at this!
-john
